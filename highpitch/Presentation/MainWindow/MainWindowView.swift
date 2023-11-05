//
//  MainWindowView.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

#if os(macOS)
import SwiftUI
import SwiftData

struct MainWindowView: View {
    // MARK: - 데이터 컨트롤을 위한 매니저 객체
    @Environment(AppleScriptManager.self)
    private var appleScriptManager
    @Environment(FileSystemManager.self)
    private var fileSystemManager
    @Environment(KeynoteManager.self)
    private var keynoteManager
    @Environment(MediaManager.self)
    private var mediaManager
    @Environment(ProjectManager.self)
    private var projectManager
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - 데이터 저장을 위한 컨텍스트 객체
    @Environment(\.modelContext)
    var modelContext
    @Query(sort: \ProjectModel.creatAt)
    var projects: [ProjectModel]
    
    @Query(
        filter: #Predicate<PracticeModel> { !$0.isVisited },
        sort: \PracticeModel.creatAt,
        order: .reverse)
    var unVisitedPractices: [PracticeModel] = []
    
    @State
    private var columnVisibility = NavigationSplitViewVisibility.all

    @ObservedObject var notiManager = NotificationManager.shared
    
    @State
    private var localProjectName = ""
    
    @State
    private var isAlertActive = false
    
    private var selected: ProjectModel? {
        projectManager.current
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            navigationSidebar
        } detail: {
            navigationDetails
        }
        .toolbarBackground(.hidden)
        .navigationTitle("Sidebar")
        .frame(
            minWidth: 1080,
            maxWidth: 1512,
            minHeight: 600,
            maxHeight: .infinity
        )
        .background(Color.HPComponent.Sidebar.background)
        .onAppear {
            NotificationManager.shared.requestAuthorization()
            receiveNotificationAndRouting()
            setup()
        }
        .onChange(of: colorScheme, { _, newValue in
            if newValue == ColorScheme.dark {
                SystemManager.shared.isDarkMode = true
            } else {
                SystemManager.shared.isDarkMode = false
            }
        })
        .onChange(of: projects) { _, newValue in
            if !newValue.isEmpty {
                projectManager.projects = newValue
                projectManager.current = newValue[0]
            }
        }
        .onChange(of: projectManager.current) { _, newValue in
            if let currnet = newValue {
                localProjectName = currnet.projectName
            }
        }
    }
}

extension MainWindowView {
    private func setup() {
//        쿼리해온 데이터에서 맨 앞 데이터 선택
//        if mediaManager.checkMicrophonePermission() {
//            print("Hello")
//            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone")
//            {
//                 NSWorkspace.shared.open(url)
//             }
//        } else {
//            
//        }
        if !unVisitedPractices.isEmpty {
            SystemManager.shared.hasUnVisited = true
        }
        if !projects.isEmpty {
            projectManager.projects = projects
            projectManager.current = projects[0]
        }
        if colorScheme == ColorScheme.dark {
            SystemManager.shared.isDarkMode = true
        } else {
            SystemManager.shared.isDarkMode = false
        }
    }
    private func receiveNotificationAndRouting() {
        NotificationCenter.default.addObserver(forName: Notification.Name("projectName"),
                                               object: nil, queue: nil) { value in
            
            let thisPractice = projects.flatMap{$0.practices}
                .first(where: {$0.creatAt == value.object as! String})
            if let practice = thisPractice {
                projectManager.currentTabItem = 1
                if !projectManager.path.isEmpty {
                  projectManager.path.removeLast()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                  projectManager.path.append(practice)
                }
                
            }
        }
    }
}

// MARK: - Views

extension MainWindowView {
    // MARK: - navigationSidebar
    @ViewBuilder
    var navigationSidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("프로젝트 이름")
                .systemFont(.body, weight: .semibold)
                .foregroundStyle(Color.HPTextStyle.darker)
                .padding(.bottom, .HPSpacing.xsmall)
                .padding(.horizontal, .HPSpacing.xxsmall)
            ScrollView {
                LazyVGrid(columns: [GridItem()], alignment: .leading) {
                    ProjectNavigationLink()
                }
            }
        }
        .frame(alignment: .topLeading)
        .navigationSplitViewColumnWidth(200)
        .padding(.top, .HPSpacing.medium)
        .background(
            Color.HPComponent.Sidebar.background)
    }
    
    // MARK: - navigationDetails
    @ViewBuilder
    var navigationDetails: some View {
        if selected != nil {
            VStack(alignment: .leading, spacing: 0) {
                projectToolbar
                VStack {
                    ProjectView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.HPComponent.Detail.background)
            .ignoresSafeArea()
        } else {
            emptyProject
        }
    }
    
    // MARK: - emptyProject
    @ViewBuilder
    var emptyProject: some View {
        VStack {
            Text("선택된 프로젝트가 없습니다.")
        }
    }
    
    // MARK: - projectToolbar
    @ViewBuilder
    var projectToolbar: some View {
        if let projectName = projectManager.current?.projectName {
            HPTopToolbar(title: projectName) {
                // MARK: - AppleScript Remove
//                if let path = projectManager.current?.keynotePath {
//                    let _path = path.absoluteString.components(separatedBy: "://")
//                    Task {
//                        await appleScriptManager.runScript(.openKeynote(fileName: _path[1].replacingOccurrences(of: "%20", with: " ")))
//                    }
//                }
            } popOverContent: {
                VStack(alignment: .leading, spacing: .HPSpacing.xxxxsmall) {
                    Text("프로젝트 명 변경하기")
                        .systemFont(.caption2)
                    VStack(spacing: .HPSpacing.xxxxsmall) {
                        TextField("set your ProjectName", text: $localProjectName)
                            .systemFont(.caption)
                        Button(action: {
                            projectManager.current?.projectName = localProjectName
                            print("projectName: \(localProjectName)")
                            Task {
                                await MainActor.run {
                                    do {
                                        try modelContext.save()
                                        print("변경됨")
                                    } catch {
                                        print("error: 변경 실패")
                                    }
                                }
                            }
                        }, label: {
                            Text("변경하기")
                        })
                    }
                }
                .padding(.vertical, .HPSpacing.xxxsmall)
                .padding(.horizontal, .HPSpacing.xsmall)
                .frame(minWidth: 200)
                .onAppear(perform: {
                    localProjectName = projectName
                })
                .onDisappear {
                    localProjectName = projectName
                }
            }
        }
    }
}

#Preview {
    MainWindowView()
        .environment(FileSystemManager())
        .environment(MediaManager())
        .environment(KeynoteManager())
        .environment(ProjectManager())
}
#endif
