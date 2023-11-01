//
//  ProjectNavigationLinkView.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI
import SwiftData

struct ProjectNavigationLink: View {
    @Environment(FileSystemManager.self)
    private var fileSystemManager
    @Environment(ProjectManager.self)
    private var projectManager
    @Environment(KeynoteManager.self)
    private var keynoteManager
    //
    @Environment(\.modelContext)
    var modelContext
    @Query(sort: \ProjectModel.creatAt)
    var projects: [ProjectModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: .HPSpacing.xxsmall) {
            VStack {
                ForEach(projects, id: \.id) { project in
                    ProjectLinkItem(
                        title : project.projectName,
                        isSelected: checkIsSelected(project.projectName)) {
                            if !projectManager.path.isEmpty {
                                projectManager.path.removeLast()
                            }
                            projectManager.current = project
                        }
                        .contextMenu {
                            Button("Delete") {
                                modelContext.delete(project)
                            }
                        }
                }
                .padding(.horizontal, .HPSpacing.xxxsmall)
            }
        }
        .padding(.bottom, .HPSpacing.xxlarge)
    }
    
}

extension ProjectNavigationLink {
    func checkIsSelected(_ projectName: String) -> Bool {
        projectName == projectManager.current?.projectName
    }
}

#Preview {
    ProjectNavigationLink()
        .environment(FileSystemManager())
        .environment(ProjectManager())
        .frame(maxWidth: 200)
        .frame(minHeight: 860)
}
