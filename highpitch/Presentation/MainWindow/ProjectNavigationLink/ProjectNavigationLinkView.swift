//
//  ProjectNavigationLinkView.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI
import SwiftData

struct ProjectNavigationLink: View {
    @Environment(ProjectManager.self)
    private var projectManager
    
//    @Query(sort: \Project.creatAt)
//    var projects: [Project]
    
    // MARK: - 임시 목업 테스트용
    var mockProject = [
        Project(projectName: "프로젝트111", creatAt: "2", practices: []),
        Project(projectName: "프로젝트222", creatAt: "2", practices: [])
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("프로젝트 이름")
            ForEach(mockProject, id: \.self) { project in
                ProjectLinkItem(
                    title : project.projectName, 
                    isSelected: checkIsSelected(project.projectName)) {
                    projectManager.current = project
                }
            }
        }
    }
}

extension ProjectNavigationLink {
    func checkIsSelected(_ projectName: String) -> Bool {
        projectName == projectManager.current?.projectName
    }
}

#Preview {
    ProjectNavigationLink()
}
