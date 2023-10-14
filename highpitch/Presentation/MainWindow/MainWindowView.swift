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
    @Environment(KeynoteManager.self)
    private var keynoteManager
    @Environment(MediaManager.self)
    private var mediaManager
    @Environment(ProjectManager.self)
    private var projectManager
        
    // MARK: - 데이터 저장을 위한 컨텍스트 객체
    @Environment(\.modelContext)
    var modelContext
    
    private var selected: Project? {
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
        if let _selected = selected {
            VStack(alignment: .leading, spacing: 0) {
                projectToolbar
                VStack {
                    ProjectView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    _selected.projectName == "프로젝트111"
                    ? Color.green
                    : Color.mint
                )
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
        HStack {
            if let projectName = projectManager.current?.projectName {
                Text("\(projectName)")
            }
        }
        .border(.blue, width: 2)
        .frame(maxWidth: .infinity, minHeight: 40)
        .background(Color.brown)
    }
}

#Preview {
    MainWindowView()
        .environment(MediaManager())
        .environment(KeynoteManager())
        .environment(ProjectManager())
}
#endif
