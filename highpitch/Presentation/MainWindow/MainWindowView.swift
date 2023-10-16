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
    
    @State
    private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    
    private var selected: Project? {
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
        .frame(minWidth: 1000, minHeight: 600)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.HPComponent.mainWindowSidebarBackground)
        .onAppear {
            setup()
        }
    }
}

extension MainWindowView {
    private func setup() {
        // 쿼리해온 데이터에서 맨 앞 데이터 선택
        let projects = fileSystemManager.loadProjects()
            projectManager.projects = projects
            projectManager.current = projects[0]
    }
}

// MARK: - Views

extension MainWindowView {
    // MARK: - navigationSidebar
    @ViewBuilder
    var navigationSidebar: some View {
        let idealWidth: CGFloat = 200
        let maxWidth: CGFloat = 300
        LazyVGrid(columns: [GridItem()], alignment: .leading) {
            ProjectNavigationLink()
        }
        .padding(.top, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.HPComponent.mainWindowSidebarBackground)
        .navigationSplitViewColumnWidth(ideal: idealWidth, max: maxWidth)
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
