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
    
    // MARK: - 데이터 저장을 위한 컨텍스트 객체
    @Environment(\.modelContext)
    var modelContext
    @Query(sort: \ProjectModel.creatAt)
    var asddsa: [ProjectModel]
    
    private var selected: ProjectModel? {
        projectManager.current
    }
    
    var body: some View {
        NavigationSplitView {
            navigationSidebar
        } detail: {
            navigationDetails
        }
        .toolbarBackground(.hidden)
        .frame(minWidth: 1000, minHeight: 600)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("FCFBFF"))
        .onAppear {
            setup()
        }
    }
}

extension MainWindowView {
    private func setup() {
        // 쿼리해온 데이터에서 맨 앞 데이터 선택
        //        let projects = fileSystemManager.loadProjects()
        //            projectManager.projects = projects
        //            projectManager.current = projects[0]
    }
}

// MARK: - Views

extension MainWindowView {
    // MARK: - navigationSidebar
    @ViewBuilder
    var navigationSidebar: some View {
        LazyVGrid(columns: [GridItem()], alignment: .leading) {
            ProjectNavigationLink()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        //        .background( Color("9A8ADA").opacity(0.05))
        .navigationSplitViewColumnWidth(ideal: 120, max: 300)
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
        ZStack {
            if let projectName = projectManager.current?.projectName {
                Text("\(projectName)")
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity)
            }
            HStack(spacing: 0) {
                Button {
                    print("키노트 열기")
                    modelContext.insert(ProjectModel(projectName: "키노트열기", creatAt: "키노트열기", keynoteCreation: "키노트열기"))
                    
                } label: {
                    Text("키노트 열기")
                        .font(.system(size: 16))
                        .frame(width: 120, height: 40)
                        .foregroundStyle(.white)
                        .background(Color("2f2f2f"))
                        .cornerRadius(10)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.trailing, 32)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, minHeight: 64)
        .background(Color("ffffff"))
        .border(Color("000000").opacity(0.1), width: 1, edges: [.bottom])
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
