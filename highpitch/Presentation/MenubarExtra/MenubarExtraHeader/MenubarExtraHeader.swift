//
//  ExtraMenubarHeader.swift
//  highpitch
//
//  Created by yuncoffee on 10/19/23.
//

import SwiftUI
import SwiftData

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
    var isRecording: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftButtonGroup
            Spacer()
            rightButtonGroup
        }
        .padding(.horizontal, .HPSpacing.xsmall + .HPSpacing.xxxxsmall)
        .frame(minHeight: 60, maxHeight: 60)
        .border(.HPComponent.stroke, width: 1, edges: [.bottom])
    }
}

// MARK: Views
extension MenubarExtraHeader {
    @ViewBuilder
    private var leftButtonGroup: some View {
        HStack(spacing: .HPSpacing.xxsmall) {
            openMainWindowButton
            openSettingWindowButton
        }
    }
    
    @ViewBuilder
    private var openMainWindowButton: some View {
        HPButton(type: .text, size: .medium, color: .HPGray.system800) {
            openSelectedProject()
        } label: { type, size, color, expandable in
            HPLabel(
                content: (label: "Home", icon: "house.fill"),
                type: type,
                size: size,
                color: color,
                alignStyle: .iconOnly,
                expandable: expandable
            )
        }
        .frame(width: 24, height: 24)
    }
    
    @ViewBuilder
    private var openSettingWindowButton: some View {
        HPButton(type: .text, size: .medium, color: .HPGray.system800) {
            try? openSettings()
        } label: { type, size, color, expandable in
            HPLabel(
                content: (label: "Open Settings", icon: "gearshape.fill"),
                type: type,
                size: size,
                color: color,
                alignStyle: .iconOnly,
                expandable: expandable
            )
        }
        .frame(width: 24, height: 24)
    }
    
    @ViewBuilder
    private var rightButtonGroup: some View {
        HStack(spacing: .HPSpacing.xsmall + .HPSpacing.xxxxsmall) {
            playAndPauseButton
            stopButton
        }
    }
    
    @ViewBuilder
    private var playAndPauseButton: some View {
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
        HPButton(type: .text, size: .medium, color: labels.color) {
            if !mediaManager.isRecording {
                playPractice()
            } else {
                pausePractice()
            }
        } label: { type, size, color, expandable in
            HPLabel(
                content: (label: labels.label, icon: labels.image),
                type: type,
                size: size,
                color: color,
                alignStyle: .iconWithTextVertical,
                iconSize: 18,
                expandable: expandable,
                fontStyle: .styled(.labeldButton)
            )
        }
        .frame(width: ButtonSize.medium.labelSize.height, height: ButtonSize.medium.labelSize.height)
        .keyboardShortcut(!mediaManager.isRecording ? "a" : .space, modifiers: [.command, .option] )
    }
    
    @ViewBuilder
    private var stopButton: some View {
        let content = (label: "끝내기", icon: "stop.fill")
        HPButton(type: .text, size: .medium, color: .HPSecondary.base) {
            Task {
                await MainActor.run {
                    stopPractice()
                }
            }
        } label: { type, size, color, expandable in
            HPLabel(
                content: content,
                type: type,
                size: size,
                color: color,
                alignStyle: .iconWithTextVertical,
                iconSize: 18,
                expandable: expandable,
                fontStyle: .styled(.labeldButton)
            )
        }
        .frame(width: ButtonSize.medium.labelSize.height, height: ButtonSize.medium.labelSize.height)
        .keyboardShortcut(.escape, modifiers: [.command, .option] )
        .disabled(!mediaManager.isRecording)
    }
}

// MARK: Methods
extension MenubarExtraHeader {
    // MARK: - 연습 시작.
    private func playPractice() {
        print("------연습이 시작되었습니다.-------")
        projectManager.playPractice(
            selectedKeynote: selectedKeynote,
            selectedProject: selectedProject,
            appleScriptManager: appleScriptManager,
            keynoteManager: keynoteManager,
            mediaManager: mediaManager
        )
    }
    
    // MARK: - 연습 일시중지
    private func pausePractice() {
        projectManager.pausePractice()
    }
    
    // MARK: - 연습 끝내기
    @MainActor
    private func stopPractice() {
        projectManager.stopPractice(
            mediaManager: mediaManager,
            keynoteManager: keynoteManager,
            modelContext: modelContext
        )
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
        } else {
            print("zz?")
        }
    }
    
    private func quitApp() {
        exit(0)
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
