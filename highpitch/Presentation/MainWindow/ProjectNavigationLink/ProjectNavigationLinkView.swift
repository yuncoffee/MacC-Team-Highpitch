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
        // TODO: - Padding
        VStack(alignment: .leading, spacing: 10) {
            Text("프로젝트 이름")
                .systemFont(.body, weight: .semibold)
                .foregroundStyle(Color.HPTextStyle.darker)
                .padding(.top, .HPSpacing.small)
                .padding(.horizontal, .HPSpacing.xxsmall)
            // TODO: - Padding
                .padding(.bottom, 10)
                .onTapGesture {
                    let newItem = ProjectModel(
                        projectName: Date.now.formatted(), creatAt: "2", keynoteCreation: "3"
                    )
                    modelContext.insert(newItem)
                    print("NavigationView: \(projects.count)")
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
                        Button("Add Practice") {
                            var utterance1 = UtteranceModel(startAt: 1000, duration: 1000, message: "안녕하세요 반갑습니다")
                            var utterance2 = UtteranceModel(startAt: 2000, duration: 2000, message: "안녕히가세요")
                            var tempUtterance = [utterance1, utterance2]
                            var tempModel = PracticeModel(practiceName: Date.now.formatted(), creatAt: "2", utterances: tempUtterance)
                            
                            project.practices.append(
                                tempModel
                            )
                        }
                        Button("녹음 시작") {
                            
                        }
                        Button("녹음 종료 및 연습 저장") {
                            
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
        .environment(FileSystemManager())
        .environment(ProjectManager())
        .frame(maxWidth: 200)
        .frame(minHeight: 860)
}
