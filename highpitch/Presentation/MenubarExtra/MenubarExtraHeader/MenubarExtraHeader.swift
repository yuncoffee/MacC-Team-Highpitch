//
//  ExtraMenubarHeader.swift
//  highpitch
//
//  Created by yuncoffee on 10/19/23.
//

import SwiftUI
import HotKey

struct MenubarExtraHeader: View {
    @Environment(\.openSettings)
    private var openSettings
    @Environment(\.openWindow)
    private var openWindow
    @Environment(AppleScriptManager.self)
    private var appleScriptManager
    @Environment(ProjectManager.self)
    private var projectManager
    @Environment(KeynoteManager.self)
    private var keynoteManager
    @Environment(MediaManager.self)
    private var mediaManager
    @Environment(\.modelContext)
    var modelContext
    @Binding
    var selectedProject: ProjectModel?
    @Binding
    var selectedKeynote: OpendKeynote?
    @Binding
    var isMenuPresented: Bool
    @Binding
    var isRecording: Bool
    var practiceManager = PracticeManager()
    
    // HotKeys
    let hotkeyStart = HotKey(key: .f5, modifiers: [.command, .control])
    let hotkeyPause = HotKey(key: .space, modifiers: [.command, .control])
    let hotkeySave = HotKey(key: .escape, modifiers: [.command, .control])
    
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
                        color: Color.HPPrimary.dark
                    )
                } else {
                    (
                        label:"일시 정지",
                        image: "pause.fill",
                        color: Color.HPGray.system800
                    )
                }
                Button {
                    if !mediaManager.isRecording {
                        playPractice()
                    } else {
                        pausePractice()
                    }
                } label: {
                    Label(labels.label, systemImage: labels.image)
                        .systemFont(.caption2)
                        .foregroundStyle(labels.color)
                        .labelStyle(VerticalIconWithTextLabelStyle())
                        .frame(height: 24)
                }
                .buttonStyle(.plain)
                .keyboardShortcut(!mediaManager.isRecording ? "a" : .space, modifiers: [.command, .option] )
                
                Button {
                    stopPractice()
                } label: {
                    Label("끝내기", systemImage: "stop.fill")
                        .systemFont(.caption2)
                        .foregroundStyle(Color.HPSecondary.base)
                        .labelStyle(VerticalIconWithTextLabelStyle())
                        .frame(height: 24)
                }
                .buttonStyle(.plain)
                .keyboardShortcut(.escape, modifiers: [.command, .option] )
            }
        }
        .padding(.horizontal, .HPSpacing.xsmall + .HPSpacing.xxxxsmall)
        .frame(minHeight: 48, maxHeight: 48)
        .border(.HPComponent.stroke, width: 1, edges: [.bottom])
        .onAppear {
            // onAppear를 통해서 hotKey들의 동작 함수들을 등록해준다.
            hotkeyStart.keyDownHandler = playPractice
            hotkeyPause.keyDownHandler = pausePractice
            hotkeySave.keyDownHandler = stopPractice
        }
    }
}

extension MenubarExtraHeader {
    // MARK: - 연습 시작.
    private func playPractice() {
        print("------연습이 시작되었습니다.-------")
        /// 선택된 키노트가 있을 때
        if let selectedKeynote = selectedKeynote {
            Task {
                await appleScriptManager.runScript(.startPresentation(fileName: selectedKeynote.path))
            }
        } else {
            /// 선택된 키노트가 없을 때
        }
        projectManager.temp = selectedProject
        keynoteManager.temp = selectedKeynote
        mediaManager.isRecording = true
        mediaManager.fileName = mediaManager.currentDateTimeString()
        mediaManager.startRecording()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isRecording.toggle()
        }
    }
    // MARK: - 연습 일시중지
    private func pausePractice() {
//        print(projectManager.temp)
//        print(projectManager.temp?.projectName)
    }
    
    // MARK: - 연습 끝내기
    private func stopPractice() {
        print("녹음 종료")
        mediaManager.isRecording.toggle()
        mediaManager.stopRecording()
        /// mediaManager.fileName에 음성 파일이 저장되어있을거다!!
        /// 녹음본 파일 위치 : /Users/{사용자이름}/Documents/HighPitch/Audio.YYYYMMDDHHMMSS.m4a
        /// ReturnZero API를 이용해서 UtteranceModel완성
        Task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isRecording.toggle()
            }
        }
        Task {
            let tempUtterances: [Utterance] = try await ReturnzeroAPIV2()
                .getResult(filePath: mediaManager.getPath(fileName: mediaManager.fileName).path())
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
            if tempUtterances.isEmpty {
                print("none of words!")
                return
            }
            /// 시작할 때 프로젝트 세팅이 안되어 있을 경우, 새 프로젝트를 생성 하고, temp에 반영한다.
            if projectManager.temp == nil {
                makeNewProject()
            }
            if let selectedProject = projectManager.temp {
                let newPracticeModel = PracticeModel(
                    practiceName: indexToOrdinalNumber(index: selectedProject.practices.count + 1)+"번째 연습",
                    index: selectedProject.practices.count,
                    isVisited: false,
                    creatAt: fileNameDateToCreateAtDate(input: mediaManager.fileName),
                    audioPath: mediaManager.getPath(fileName: mediaManager.fileName),
                    utterances: newUtteranceModels,
                    summary: PracticeSummaryModel()
                )
                selectedProject.practices.append(newPracticeModel)
                practiceManager.current = newPracticeModel
                Task {
                    await MainActor.run {
                        practiceManager.getPracticeDetail()
                    }
                }
            }
            await NotificationManager.shared.sendNotification(name: practiceManager.current?.practiceName ?? "err")
        }
    }
    
    func indexToOrdinalNumber(index: Int) -> String {
        let ordinalNumber = ["첫", "두", "세", "네", "다섯", "여섯", "일곱", "여덟", "아홉", "열",
                             "열한", "열두", "열세", "열네", "열다섯", "열여섯", "열일곱", "열여덟"]
        
        if ordinalNumber.count < index {
            return "Index 초과"
        }
        return ordinalNumber[index]
    }
    
    private func makeNewProject() {
        let newProject = ProjectModel(
            projectName: "새 프로젝트",
            creatAt: Date.now.formatted(),
            keynotePath: nil,
            keynoteCreation: "temp"
        )
        if let selectedKeynote = keynoteManager.temp {
            newProject.keynoteCreation = selectedKeynote.creation
            newProject.keynotePath = URL(fileURLWithPath: selectedKeynote.path)
            newProject.projectName = selectedKeynote.getFileName()
        }
        modelContext.insert(newProject)
        projectManager.temp = newProject
    }
    
    private func openSelectedProject() {
        if let selectedProject = selectedProject {
            if selectedProject.projectName != "새 프로젝트" {
                projectManager.current = selectedProject
                if !projectManager.path.isEmpty {
                    projectManager.currentTabItem = 0
                    projectManager.path.removeLast()
                }
                openWindow(id: "main")
            }
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
