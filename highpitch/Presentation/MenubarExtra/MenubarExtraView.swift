//
//  MenubarExtraView.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

#if os(macOS)
import SwiftUI
import SwiftData

struct MenubarExtraView: View {
    @Environment(\.openWindow)
    private var openWindow
    
    @Environment(AppleScriptManager.self)
    private var appleScriptManager
    @Environment(FileSystemManager.self)
    private var fileSystemManager
    @Environment(KeynoteManager.self)
    private var keynoteManager
    @Environment(MediaManager.self)
    private var mediaManager
    @Environment(ProjectManager.self)
    private var projectManager
    
    @Environment(\.modelContext)
    var modelContext
    @Query(sort: \ProjectModel.creatAt)
    var projectModels: [ProjectModel]
    
    @State
    private var keynoteOptions: [OpendKeynote] = []
    @State
    private var isRecording = false
    
    @Binding
    var refreshable: Bool
    @Binding
    var selectedProject: ProjectModel?
    @Binding
    var selectedKeynote: OpendKeynote?
    
    var body: some View {
            ZStack {
                Text("  ")
                    .frame(width: 45, height: 1)
                    .popover(isPresented: $isRecording, arrowEdge: .bottom) {
                        let message = mediaManager.isRecording ? "연습 녹음이 시작되었어요!" : "연습 녹음 저장이 완료되었어요!"
                        Text("\(message)")
                            .padding()
                    }
                    .frame(alignment: .center)
                VStack(spacing: 0) {
                    MenubarExtraHeader(
                        selectedProject: $selectedProject,
                        selectedKeynote: $selectedKeynote,
                        isRecording: $isRecording
                    )
                    MenubarExtraContent(
                        selectedProject: $selectedProject,
                        selectedKeynote: $selectedKeynote,
                        keynoteOptions: $keynoteOptions
                    )
                    if projectManager.current != nil {
                        MenubarExtraFooter(selectedProject: $selectedProject)
                    }
                }
                .frame(
                    width: isRecording ? 0 : 400,
                    height: isRecording ? 0 : 440,
                    alignment: .top
                )
                .background(Color.HPComponent.Detail.background)
            }
            .frame(alignment: .top)
            .onChange(of: refreshable, { _, newValue in
                getIsActiveKeynoteApp()
                updateOpendKeynotes()
            })
            .onChange(of: keynoteManager.isKeynoteProcessOpen, { _, newValue in
                if newValue {
                    updateOpendKeynotes()
                }
            })
            .onChange(of: keynoteManager.opendKeynotes) { _, newValue in
                keynoteOptions = newValue
                if !newValue.isEmpty {
                    selectedKeynote = newValue[0]
                }
                updateCurrentProject()
            }
            .onChange(of: selectedKeynote, {
                updateCurrentProject()
            })
            .onChange(of: mediaManager.isRecording) { _, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isRecording = true
                }
            }
            .onDisappear {
                refreshable = false
            }
    }
}

// MARK: - Methods
extension MenubarExtraView {
    /// 키노트가 열려있는지 조회 후 상태 처리
    private func getIsActiveKeynoteApp() {
        Task {
            let result = await appleScriptManager.runScript(.isActiveKeynoteApp)
            if case .boolResult(let isKeynoteOpen) = result {
                keynoteManager.isKeynoteProcessOpen = isKeynoteOpen
            }
        }
    }
    
    private func updateOpendKeynotes() {
        Task {
            if keynoteManager.isKeynoteProcessOpen {
                let result = await appleScriptManager.runScript(.getOpendKeynotes)
                if case .stringArrayResult(let keynotePaths) = result {
                    let opendKeynotes = keynotePaths.map { path in
                        OpendKeynote(path: path, creation: fileSystemManager.getCreationMetadata(path))
                    }
                    keynoteManager.opendKeynotes = opendKeynotes
                }
            }
        }
    }
    
    private func updateCurrentProject() {
        // MARK: - 열려있는 키노트가 없으면
        if keynoteManager.opendKeynotes.isEmpty {
            selectedProject = nil
        } else {
            // MARK: - 열려있는 키노트가 있다면
            // MARK: - 만들어 둔 프로젝트가 있다면
            if !projectModels.isEmpty {
                if let selectedKeynote = selectedKeynote {
                    let filtered = projectModels.filter({ project in
                        project.keynoteCreation == selectedKeynote.creation
                    })
                    if !filtered.isEmpty {
                        print("일치하는 프로젝트: \(filtered[0].projectName)")
                        projectManager.current = filtered[0]
                        selectedProject = filtered[0]
                    } else {
                        print("일치하는 프로젝트가 없음")
                        selectedProject = nil
                    }
                }
            }
        }
    }
}

// #Preview {
//    return MenubarExtraView()
//        .environment(AppleScriptManager())
//        .environment(MediaManager())
//        .environment(KeynoteManager())
//        .frame(maxWidth: 360, maxHeight: 480)
// }
#endif
