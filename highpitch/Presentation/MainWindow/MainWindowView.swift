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
        .onChange(of: projects) { oldValue, newValue in
            if !newValue.isEmpty {
                projectManager.projects = newValue
                projectManager.current = newValue[0]
            }
        }
    }
}

extension MainWindowView {
    private func setup() {
//        쿼리해온 데이터에서 맨 앞 데이터 선택
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
            if let practices = projectManager.current?.practices.sorted() {
                projectManager.currentTabItem = 1
                if !projectManager.path.isEmpty {
                  projectManager.path.removeLast()
                }
                if let practiceName = value.object as? String {
                    if practiceName != "err" {
                        let latestPractice = practices.first { practice in
                            practice.practiceName == practiceName
                        }
                        guard let appendablePractice = latestPractice else {
                            return
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                          projectManager.path.append(appendablePractice)
                        }
                    }
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
            HPTopToolbar(title: projectName)
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
