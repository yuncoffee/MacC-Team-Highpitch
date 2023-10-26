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

                // == 기능 Test를 위해서 임시로 만든 contextMenu (나중에 기능 완성되면 삭제가능)==!!!!
                    .contextMenu {
                        Button("Delete") {
                            modelContext.delete(project)
                        }
//                        Button("Add Practice") {
//                            /// --- Test 1 연습
//                            let TEST_ONE_KEY = Bundle.main.url(forResource: "test1", withExtension: "key")
//                            let TEST_ONE_M4A = Bundle.main.url(forResource: "test1", withExtension: "m4a")
//                            let TEST_ONE_JSON = Bundle.main.url(forResource: "test1", withExtension: "json")
//                            /// --- Test 2 연습
//                            let TEST_TWO_KEY = Bundle.main.url(forResource: "test2", withExtension: "key")
//                            let TEST_TWO_M4A = Bundle.main.url(forResource: "test2", withExtension: "m4a")
//                            let TEST_TWO_JSON = Bundle.main.url(forResource: "test2", withExtension: "json")
//                            
//                            for index in 0...1 {
//                                do {
//                                    let data = try Data(contentsOf: index == 0 ? TEST_ONE_JSON! : TEST_TWO_JSON!)
//                                    let decoder = JSONDecoder()
//                                    let jsonModel = try decoder.decode(SampleProjectJson.self, from: data)
//                                    var practice = PracticeModel(
//                                        practiceName: "연습 \(index)",
//                                        index: index,
//                                        isVisited: false,
//                                        creatAt: Date().m4aNameToCreateAt(input: Date().makeM4aFileName()),
//                                        audioPath: index == 0 ? TEST_ONE_M4A! : TEST_TWO_M4A!,
//                                        utterances: [], summary: PracticeSummaryModel()
//                                    )
//                                    
//                                    var tempUtterance: [UtteranceModel] = []
//                                    
//                                    jsonModel.utterances.forEach { utterance in
//                                        tempUtterance.append(UtteranceModel(
//                                            startAt: utterance.startAt,
//                                            duration: utterance.duration,
//                                            message: utterance.message
//                                        ))
//                                    }
//                                    
//                                    practice.utterances = tempUtterance
//                                    project.practices.append(practice)
//                                    practiceManager.current = practice
//                                    practiceManager.getPracticeDetail()
//                                    
//                                } catch {
//                                    print("파일 또는 디코딩 에러")
//                                }
//                            }
//                            
//                        }
                        // MARK: 세바시 연습 추가 버튼 나중에 삭제 가능
//                        Button("세바시 연습 추가") {
//                            // /Users/leejaehyuk/Downloads/kimji.m4a
//                            Task {
//                                let tempUtterances: [Utterance] = try await ReturnzeroAPI()
//                                    .getResult(filePath: "/Users/coffee/Downloads/a.m4a")
//                                var newUtteranceModels: [UtteranceModel] = []
//                                for tempUtterance in tempUtterances {
//                                    newUtteranceModels.append(
//                                        UtteranceModel(
//                                            startAt: tempUtterance.startAt,
//                                            duration: tempUtterance.duration,
//                                            message: tempUtterance.message
//                                        )
//                                    )
//                                }
//                                /// 시작할 때 프로젝트 세팅이 안되어 있을 경우, 새 프로젝트를 생성 하고, temp에 반영한다.
//                                if projectManager.temp == nil {
//                                    let newProject = ProjectModel(
//                                        projectName: "새 프로젝트 1",
//                                        creatAt: Date.now.formatted(),
//                                        keynotePath: nil,
//                                        keynoteCreation: "temp"
//                                    )
//                                    if let selectedKeynote = keynoteManager.temp {
//                                        newProject.keynoteCreation = selectedKeynote.creation
//                                        newProject.keynotePath = URL(fileURLWithPath: selectedKeynote.path)
//                                        newProject.projectName = selectedKeynote.getFileName()
//                                    }
//                                    modelContext.insert(newProject)
//                                    projectManager.temp = newProject
//                                }
//                                if let selectedProject = projectManager.temp {
//                                    let newPracticeModel = PracticeModel(
//                                        practiceName: "\(selectedProject.practices.count + 1)번째 연습",
//                                        index: selectedProject.practices.count,
//                                        isVisited: false,
//                                        creatAt: Date().m4aNameToCreateAt(input: Date().makeM4aFileName()),
//                                        audioPath: URL(string: "/Users/coffee/Downloads/a.m4a"),
//                                        utterances: newUtteranceModels,
//                                        summary: PracticeSummaryModel()
//                                    )
//                                    selectedProject.practices.append(newPracticeModel)
//                                    practiceManager.current = newPracticeModel
//                                    await MainActor.run {
//                                        practiceManager.getPracticeDetail()
//                                    }
//                                }
//                            }
//                        }
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
