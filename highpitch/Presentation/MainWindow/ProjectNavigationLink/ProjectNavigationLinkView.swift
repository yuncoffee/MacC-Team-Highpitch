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
        
//    @Query(sort: \Project.creatAt)
//    var projects: [Project]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("프로젝트 이름")
                .systemFont(.body, weight: .semibold)
                .foregroundStyle(Color.HPTextStyle.darker)
                .padding(.top, 24)
                .padding(.horizontal, 12)
                .padding(.bottom, 10)
            if let projects = projectManager.projects {
                ForEach(projects, id: \.id) { project in
                    ProjectLinkItem(
                        title : project.projectName,
                        isSelected: checkIsSelected(project.projectName)) {
                            if !projectManager.path.isEmpty {
                                projectManager.path.removeLast()
                        }
                        projectManager.current = project
                    }
                }
                .padding(.leading, 8)
                .padding(.trailing, 12)
            }
        }
        .frame(
            maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
            maxHeight: .infinity,
            alignment: .topLeading
        )
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
