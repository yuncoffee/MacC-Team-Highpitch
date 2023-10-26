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
    
    var practiceManager = PracticeManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: .HPSpacing.xxsmall) {
            Text("프로젝트 이름")
                .systemFont(.body, weight: .semibold)
                .foregroundStyle(Color.HPTextStyle.darker)
                .padding(.top, .HPSpacing.small)
                .padding(.horizontal, .HPSpacing.xxsmall)
                .padding(.bottom, .HPSpacing.xsmall)

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
