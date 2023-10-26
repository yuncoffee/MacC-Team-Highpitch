//
//  MenubarExtraView.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

/**
 /// 1. 현재 선택 된 프로젝트 정보 출력 출력
 /// 2. 선택 된 프로젝트로 연습 하기
 /// 키노트 있을 때만 동작 ->
 ///     2.1 프로젝트가 없을 경우 // 키노트가 열려있을 때만! 없으면 앱 열기
 ///     2.2 프로젝트가 있고, 현재 맨 앞의 키노트와 일치하는 경우 // (굿)
 ///     2.3 프로젝트가 있는데, 현재 맨 앞의 키노트와 일치하지 않는 경우 // 사용자가 설정할 수도?
 ///     2.4 프로젝트가 있는데, 열려있는 모든 키노트와 일치하지 않는 경우 // 안될수도 있어서,,
 ///     2-1-1: 노티피케이션 주기
 /// 3. 연습 그만하기
 /// 4. 프로젝트의 연습 목록
 /// 5. 프로젝트 창 열기
 /// 6. 앱 종료
 
 플러그인
 프로젝트 시작 시 Highpitch 프로젝트로 연결
 프로젝트 있을 시 /없을 시 구분
 종료 시 기능
 음성 파일 저장
 STT택스트 구현 및 저장
 피드백 및 표시해야할 부분을 가공해서 데이터로 저장
 앱 열기
 앱 종료
 
 /// 현재 선택된 키노트 프로젝트를 확인한다.
 /// 앱이 실행 되었을 경우..
 /// 현재 키노트가 열려져 있는지 확인한다.
 /// 키노트가 열려져 있다면?
 ///     - 1. 열려 있는 모든 키노트에서 경로를 조회한다.
 ///     - 2. 조회한 경로를 통해 생성일을 구한다.
 ///     - 3. 생성일로 저장해 놓은 프로젝트를 조회한다.
 ///     - 4.1. 일치하는 프로젝트가 있다면?
 ///             - 그 프로젝트를 selected를 세팅한다.
 ///     - 4.2. 일치하는 프로젝트가 없다면?
 ///             - 새 프로젝트를 selected에 세팅한다.
 ///     - 일치하는 프로젝트 목록으로 Picker의 옵션을 구성한다.
 /// 키노트가 열려져 있지 않다면?
 ///     - 우선 연습 못하게 disabled 처리하자.
 
 */
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
    private var selectedProject: ProjectModel?
    @State
    private var selectedKeynote: OpendKeynote?
    @State
    private var isRecording = false
    
    @Binding
    var isMenuPresented: Bool
    
    var body: some View {
        if isMenuPresented {
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
                        isMenuPresented: $isMenuPresented,
                        isRecording: $isRecording
                    )
                    MenubarExtraContent(
                        selectedProject: $selectedProject,
                        selectedKeynote: $selectedKeynote,
                        keynoteOptions: $keynoteOptions,
                        isMenuPresented: $isMenuPresented
                    )
                }
                .frame(
                    width: isRecording ? 0 : 400,
                    height: isRecording ? 0 : 440,
                    alignment: .top
                )
                .background(Color.HPGray.systemWhite)
            }
            .frame(alignment: .top)
            .onAppear {
                getIsActiveKeynoteApp()
                updateOpendKeynotes()
            }
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
            if projectModels.count > 1 {
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

#Preview {
    @State var value: Bool = true
    return MenubarExtraView(isMenuPresented: $value)
        .environment(AppleScriptManager())
        .environment(MediaManager())
        .environment(KeynoteManager())
        .frame(maxWidth: 360, maxHeight: 480)
}
#endif

// MARK: Date.now() -> String으로 변환하는 함수들
extension MenubarExtraView {
    // MediaManager밑에 있는 fileName을 통해서 createAt에 넣을 날짜 생성
    func fileNameDateToCreateAtDate(input: String) -> String {
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
