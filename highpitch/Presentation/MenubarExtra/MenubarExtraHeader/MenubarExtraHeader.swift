//
//  ExtraMenubarHeader.swift
//  highpitch
//
//  Created by yuncoffee on 10/19/23.
//

import SwiftUI

struct MenubarExtraHeader: View {
    @Environment(\.openSettings)
    private var openSettings
    @Environment(\.openWindow)
    private var openWindow
    @Environment(AppleScriptManager.self)
    private var appleScriptManager
    @Environment(ProjectManager.self)
    private var projectManager
    @Environment(MediaManager.self)
    private var mediaManager
    @Binding
    var selectedProject: ProjectModel
    @Binding
    var selectedKeynote: OpendKeynote
    @Binding
    var isMenuPresented: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: .HPSpacing.xsmall) {
                Button {
                    print("앱 열기")
                    openSelectedProject()
                } label: {
                    Label("홈", systemImage: "house.fill")
                        .systemFont(.caption)
                        .foregroundStyle(Color.HPGray.system800)
                        .labelStyle(.iconOnly)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                Button {
                    print("설정창 열기...")
                    try? openSettings()
                } label: {
                    Label("설정창 열기", systemImage: "gearshape.fill")
                        .systemFont(.caption)
                        .foregroundStyle(Color.HPGray.system800)
                        .labelStyle(.iconOnly)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
            }
            Spacer()
            HStack(spacing: .HPSpacing.xsmall) {
                let labels = if !mediaManager.isRecording {
                    (
                        label:"연습 시작",
                        image: "play.fill",
//                        func: playPractice(),
                        color: Color.HPPrimary.base
                    )
                } else {
                    (
                        label:"일시 정지",
                        image: "pause.fill",
//                        func: pausePractice(),
                        color: Color.HPGray.system800
                    )
                }
                Button {
                    if !mediaManager.isRecording {
                        playPractice()
                    } else {
                        pausePractice()
                    }
//                    labels.func
                } label: {
                    Label(labels.label, systemImage: labels.image)
                        .systemFont(.body)
                        .foregroundStyle(labels.color)
                        .labelStyle(.iconOnly)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                Button {
                    stopPractice()
                } label: {
                    Label("연습 끝내기", systemImage: "stop.fill")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPGray.system800)
                        .labelStyle(.iconOnly)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, .HPSpacing.xsmall + .HPSpacing.xxxxsmall)
        .frame(minHeight: 48, maxHeight: 48)
        .border(.HPComponent.stroke, width: 1, edges: [.bottom])
    }
}

extension MenubarExtraHeader {
    // MARK: - 연습 시자기.
    private func playPractice() {
        print("..?")
//        Task {
//            await appleScriptManager.runScript(.startPresentation(fileName: selectedKeynote.path))
//        }
//        mediaManager.isRecording.toggle()
//        isMenuPresented.toggle()
        
        // 녹음파일 저장할 fileName 정하고, 녹음 시작!!!
//        mediaManager.fileName = mediaManager.currentDateTimeString()
//        mediaManager.startRecording()
    }
    // MARK: - 연습 일시중지
    private func pausePractice() {
        
    }
    
    // MARK: - 연습 끝내기
    private func stopPractice() {
        print("녹음 종료")
        mediaManager.isRecording.toggle()
        
        // 녹음 중지!
        mediaManager.stopRecording()
        // mediaManager.fileName에 음성 파일이 저장되어있을거다!!
        // 녹음본 파일 위치 : /Users/{사용자이름}/Documents/HighPitch/Audio.YYYYMMDDHHMMSS.m4a
        // ReturnZero API를 이용해서 UtteranceModel완성
        Task {
            // MARK: 여기다!!!!!!!!여기다!!!!!!!!여기다!!!!!!!!여기다!!!!!!!!여기다!!!!!!!!
            let tempUtterances: [Utterance] = try await ReturnzeroAPI()
                .getResult(filePath: mediaManager.getPath(fileName: mediaManager.fileName).path())
            // MARK: 여기다!!!!!!!!여기다!!!!!!!!여기다!!!!!!!!여기다!!!!!!!!여기다!!!!!!!!
            var newUtteranceModels: [UtteranceModel] = []
            
            for tempUtterance in tempUtterances {
                newUtteranceModels.append(
                    UtteranceModel(
                        startAt: tempUtterance.startAt,
                        duration: tempUtterance.duration,
                        message: tempUtterance.message
                    )
                )
            }
            
            // 새로운 녹음에 대한 PracticeModel을 만들어서 넣는다!
            let newPracticeModel = PracticeModel(
                practiceName: "\(selectedProject.practices.count + 1)번째 연습",
                index: selectedProject.practices.count,
                isVisited: false,
                creatAt: fileNameDateToCreateAtDate(input: mediaManager.fileName),
                audioPath: mediaManager.getPath(fileName: mediaManager.fileName),
                utterances: newUtteranceModels,
                summary: PracticeSummaryModel()
            )
            selectedProject.practices.append(newPracticeModel)
        }
    }
    
    private func openSelectedProject() {
        print("프로젝트 열기")
        if selectedProject.projectName != "새 프로젝트" {
            projectManager.current = selectedProject
            if !projectManager.path.isEmpty {
                projectManager.currentTabItem = 0
                projectManager.path.removeLast()
            }
            openWindow(id: "main")
        }
    }
    private func quitApp() {
        exit(0)
    }
    
    // MediaManager밑에 있는 fileName을 통해서 createAt에 넣을 날짜 생성
    private func fileNameDateToCreateAtDate(input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyyMMddHHmmss"
        
        if let date = inputFormatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
            
            let formattedDate = outputFormatter.string(from: date)
            
            return formattedDate
        } else {
            return "Invalid Date"
        }
    }
}

// #Preview {
//    @State
//    var selectedProject: ProjectModel = ProjectModel(
//        projectName: "d",
//        creatAt: "d",
//        keynoteCreation: "dd"
//    )
//    return MenubarExtraHeader(selectedProject: $selectedProject)
// }
