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
    
    var practiceManager = PracticeManager()
    
    var body: some View {
//    TODO: - Padding
        VStack(alignment: .leading, spacing: 10) {
            Text("프로젝트 이름")
                .systemFont(.body, weight: .semibold)
                .foregroundStyle(Color.HPTextStyle.darker)
                .padding(.top, .HPSpacing.small)
                .padding(.horizontal, .HPSpacing.xxsmall)
//        TODO: - Padding
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
                // == 기능 Test를 위해서 임시로 만든 contextMenu (나중에 기능 완성되면 삭제가능)==!!!!
                    .contextMenu {
                        Button("Delete") {
                            modelContext.delete(project)
                        }
                        Button("Add Practice") {
                            /// --- Test 1 연습
                            let TEST_ONE_KEY = Bundle.main.url(forResource: "test1", withExtension: "key")
                            let TEST_ONE_M4A = Bundle.main.url(forResource: "test1", withExtension: "m4a")
                            let TEST_ONE_JSON = Bundle.main.url(forResource: "test1", withExtension: "json")
                            /// --- Test 2 연습
                            let TEST_TWO_KEY = Bundle.main.url(forResource: "test2", withExtension: "key")
                            let TEST_TWO_M4A = Bundle.main.url(forResource: "test2", withExtension: "m4a")
                            let TEST_TWO_JSON = Bundle.main.url(forResource: "test2", withExtension: "json")
                            
                            for index in 0...1 {
                                do {
                                    let data = try Data(contentsOf: index == 0 ? TEST_ONE_JSON! : TEST_TWO_JSON!)
                                    let decoder = JSONDecoder()
                                    let jsonModel = try decoder.decode(SampleProjectJson.self, from: data)
                                    var practice = PracticeModel(
                                        practiceName: "연습 \(index)",
                                        index: index,
                                        isVisited: false,
                                        creatAt: "2023-10-18",
                                        audioPath: index == 0 ? TEST_ONE_M4A! : TEST_TWO_M4A!,
                                        utterances: [], summary: PracticeSummaryModel()
                                    )
                                    
                                    var tempUtterance: [UtteranceModel] = []
                                    
                                    jsonModel.utterances.forEach { utterance in
                                        tempUtterance.append(UtteranceModel(
                                            startAt: utterance.startAt,
                                            duration: utterance.duration,
                                            message: utterance.message
                                        ))
                                    }
                                    
                                    practice.utterances = tempUtterance
                                    project.practices.append(practice)
                                    practiceManager.current = practice
                                    practiceManager.getPracticeDetail()
                                    
                                } catch {
                                    print("파일 또는 디코딩 에러")
                                }
                            }
                            
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
