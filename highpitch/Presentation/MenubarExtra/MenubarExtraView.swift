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
 
 */
#if os(macOS)
import SwiftUI

struct MenubarExtraView: View {
    @Environment(AppleScriptManager.self)
    private var appleScriptManager
    @Environment(FileSystemManager.self)
    private var fileSystemManager
    @Environment(MediaManager.self)
    private var mediaManager
    @Environment(KeynoteManager.self)
    private var keynoteManager
    
    @State
    var keynoteOptions: [OpendKeynote] = []
    
    @State
    var selectedkeynote: OpendKeynote = OpendKeynote()
    
    @State
    var selected = "새 프로젝트"
    
    @State
    var options = ["새 프로젝트", "프로젝트 1", "프로젝트 2", "프로젝트 3"]
    
    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            sectionProject
            Divider()
            sectionPractice
            Divider()
            footer
        }
        .frame(minWidth: 360, minHeight: 480, alignment: .topLeading)
        .background(Color.white)
        .onAppear {
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

            updateOpendKeynotes()
        }
        .onChange(of: keynoteManager.opendKeynotes) { _, newValue in
            keynoteOptions = newValue
            selectedkeynote = newValue[0]
        }
    }
}

extension MenubarExtraView {
    private func getIsActiveKeynoteApp() {
        Task {
            let result = await appleScriptManager.runScript(.isActiveKeynoteApp)
            if case .boolResult(let isKeynoteOpen) = result {
                // logic 2
                keynoteManager.isKeynoteProcessOpen = isKeynoteOpen
            }
        }
    }
    
    private func updateOpendKeynotes() {
        Task {
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

// MARK: - Views
extension MenubarExtraView {
    @ViewBuilder
    private var header: some View {
        HStack {
            Button {
                print("앱 열기")
            } label: {
                Label("홈", systemImage: "house.fill")
                    .labelStyle(.iconOnly)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
            Spacer()
            Button {
                print("프로젝트 열기")
                updateOpendKeynotes()
  
            } label: {
                Label("프로젝트 열기", systemImage: "house.fill")
                    .labelStyle(.titleOnly)
            }
            
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
    }
    @ViewBuilder
    private var sectionProject: some View {
        // 프로젝트의 연습 목록
        HStack(alignment: .bottom) {
            // 현재 선택 된 프로젝트 정보 출력 출력
            /// 키노트가 열려있는 경우,
            VStack(alignment: .leading) {
                Text("현재 열려있는 키노트")
                Picker("프로젝트", selection: $selectedkeynote) {
                    ForEach(keynoteOptions, id: \.self) { opendKeynote in
                        Text("\(opendKeynote.getFileName())").tag(opendKeynote)
                    }
                }
                .labelsHidden()
                Text("프로젝트")
                Picker("프로젝트", selection: $selected) {
                    ForEach(options, id: \.self) { option in
                        Text("\(option)")
                    }
                }
                .labelsHidden()
            }
            Spacer()
            // 선택 된 프로젝트로 연습 하기 || 연습 그만하기
            Button {
                if !mediaManager.isRecording {
                    print("녹음 시작")
                } else {
                    print("녹음 종료")
                }
            } label: {
                Label(
                    !mediaManager.isRecording
                    ? "연습 시작하기"
                    : "연습 종료하기",
                    systemImage: !mediaManager.isRecording
                    ? "play.fill"
                    : "stop.circle.fill"
                )
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
        .frame(minHeight: 32)
    }
    @ViewBuilder
    private var sectionPractice: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVGrid(columns: [GridItem()], spacing: 8) {
                    ForEach(1...5, id: \.self) { index in
                        HStack {
                            Text("\(index)")
                            Spacer()
                            Text("자세히 보기")
                        }
                        .padding()
                        .background(Color("000000").opacity(0.1))
                        .cornerRadius(5)
                    }
                    
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 24)
        }
    }
    @ViewBuilder
    private var footer: some View {
        
        // 프로젝트 창 열기
        // 앱 종료
        HStack {
            Spacer()
            Button {
                exit(0)
            } label: {
                Text("앱 종료하기")
            }
        }
        .frame(minHeight: 32)
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
    }
}

#Preview {
    MenubarExtraView()
        .environment(AppleScriptManager())
        .environment(MediaManager())
        .environment(KeynoteManager())
        .frame(maxWidth: 360, maxHeight: 480)
}
#endif
