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
    
    //
    @Environment(\.modelContext)
    var modelContext
    @Query(sort: \ProjectModel.creatAt)
    var projects: [ProjectModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("프로젝트 이름")
                .font(Font.system(size: 16))
                .foregroundStyle(Color("000000").opacity(0.5))
                .padding(.top, 24)
                .padding(.horizontal, 24)
                .padding(.bottom, 10)
                .onTapGesture {
                    let newItem = ProjectModel(projectName: "1", creatAt: "2", keynoteCreation: "3")
                    modelContext.insert(newItem)
                }
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
        .environment(ProjectManager())
        .frame(maxWidth: 200)
        .frame(minHeight: 860)
}
