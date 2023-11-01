//
//  ProjectManager.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class ProjectManager {
    // MARK: - 임시 샘플 프로젝트들 저장
    var projects: [ProjectModel]?
    var current: ProjectModel?
    var temp: PersistentIdentifier?
    var currentTabItem = 1
    var path: NavigationPath = .init()
}

extension ProjectManager {
    // MARK: 연습 시작하기
    func playPractice(
        selectedKeynote: OpendKeynote?,
        selectedProject: ProjectModel?,
        appleScriptManager: AppleScriptManager,
        keynoteManager: KeynoteManager,
        mediaManager: MediaManager
    ) {
        if let selectedKeynote = selectedKeynote {
            Task {
                await appleScriptManager.runScript(.startPresentation(fileName: selectedKeynote.path))
            }
        } else {
            /// 선택된 키노트가 없을 때
        }
        temp = selectedProject?.persistentModelID
        keynoteManager.temp = selectedKeynote
        mediaManager.fileName = Date().makeM4aFileName()
        mediaManager.startRecording()
    }
    
    func pausePractice() {
        print("pause!")
    }
    
    @MainActor
    func stopPractice(
        mediaManager: MediaManager,
        keynoteManager: KeynoteManager,
        modelContext: ModelContext
    ) {
        if !mediaManager.isRecording {
            return
        }
        print("녹음 종료")
        mediaManager.stopRecording()
        /// mediaManager.fileName에 음성 파일이 저장되어있을거다!!
        /// 녹음본 파일 위치 : /Users/{사용자이름}/Documents/HighPitch/Audio.YYYYMMDDHHMMSS.m4a
        /// ReturnZero API를 이용해서 UtteranceModel완성
        Task {
            let newUtteranceModels = await makeNewUtterances(mediaManager: mediaManager)
            /// 아무말도 하지 않았을 경우 종료한다.
            if newUtteranceModels.isEmpty {
                print("none of words!")
                return
            }
            /// 시작할 때 프로젝트 세팅이 안되어 있을 경우, 새 프로젝트를 생성 하고, temp에 반영한다.
            /// temp는 새로 만들어진 ProjectModel.persistentModelID 을 들고 있다.
            if temp == nil {
                makeNewProject(keynoteManager: keynoteManager, modelContext: modelContext)
            }
            /// 생성한 ID로 프로젝트 모델을 가져온다.
            guard let id = temp else { return }
            guard let tempProject = modelContext.model(for: id) as? ProjectModel else { return }
            let newPracticeModel = makeNewPractice(
                project: tempProject,
                utterances: newUtteranceModels,
                mediaManager: mediaManager
            )
            /// 프로젝트에 추가한다.
            tempProject.practices.append(newPracticeModel)
            /// words, sentences, summary를 처리한다.
            PracticeManager.getPracticeDetail(practice: newPracticeModel)
            temp = nil
            if current == nil {
                current = tempProject
            }
            NotificationManager.shared.sendNotification(
                name: newPracticeModel.practiceName
            )
        }
    }
    
    private func makeNewUtterances(mediaManager: MediaManager) async -> [UtteranceModel] {
        var result: [UtteranceModel] = []
        do {
            let tempUtterances: [Utterance] = try await ReturnzeroAPI()
                .getResult(filePath: mediaManager.getPath(fileName: mediaManager.fileName).path())
            for tempUtterance in tempUtterances {
                result.append(
                    UtteranceModel(
                        startAt: tempUtterance.startAt,
                        duration: tempUtterance.duration,
                        message: tempUtterance.message
                    )
                )
            }
        } catch {
            print(error)
        }
        return result
    }
    
    private func makeNewProject(keynoteManager: KeynoteManager, modelContext: ModelContext) {
        let newProject = ProjectModel(
            projectName: "\(Date.now.formatted())",
            creatAt: Date.now.formatted(),
            keynotePath: nil,
            keynoteCreation: "temp"
        )
        if let selectedKeynote = keynoteManager.temp {
            newProject.keynoteCreation = selectedKeynote.creation
            newProject.keynotePath = URL(fileURLWithPath: selectedKeynote.path)
            newProject.projectName = selectedKeynote.getFileName().components(separatedBy: ".")[0]
        }
        modelContext.insert(newProject)
        temp = newProject.persistentModelID
    }
    
    private func makeNewPractice(
        project: ProjectModel,
        utterances: [UtteranceModel],
        mediaManager: MediaManager
    ) -> PracticeModel {
        /// 새 연습 모델을 생성한다.
        let result = PracticeModel(
            practiceName: "init",
            index: -1,
            isVisited: false,
            creatAt: Date().m4aNameToCreateAt(input: mediaManager.fileName),
            audioPath: mediaManager.getPath(fileName: mediaManager.fileName),
            utterances: utterances,
            summary: PracticeSummaryModel()
        )

        if project.practices.count == 0 {
            result.index = 0
            result.practiceName = indexToOrdinalNumber(index: 0) + "번째 연습"
        } else {
            let latestIndex = project.practices.sorted(by: {$0.creatAt > $1.creatAt}).first?.index
            if let latestIndex = latestIndex {
                result.index = latestIndex + 1
                result.practiceName = indexToOrdinalNumber(index: latestIndex + 1)
            }
        }
        return result
    }
    
    private func indexToOrdinalNumber(index: Int) -> String {
        let ordinalNumber = ["첫", "두", "세", "네", "다섯", "여섯", "일곱", "여덟", "아홉", "열",
                             "열한", "열두", "열세", "열네", "열다섯", "열여섯", "열일곱", "열여덟"]
        
        if ordinalNumber.count < index {
            return "Index 초과"
        }
        return ordinalNumber[index]
    }
}
