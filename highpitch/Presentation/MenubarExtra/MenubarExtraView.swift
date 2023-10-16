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
    
    @State
    private var selectedProject: Project = Project()
    @State
    private var selectedkeynote: OpendKeynote = OpendKeynote()
    @State
    private var projectOptions: [Project] = []
    @State
    private var keynoteOptions: [OpendKeynote] = []
    
    @Binding
    var isMenuPresented: Bool
    
    var body: some View {
        if isMenuPresented {
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
                getIsActiveKeynoteApp()
                updateOpendKeynotes()
                if let projects = projectManager.projects {
                    projectOptions = projects
                    projectOptions.append(Project())
                    selectedProject = projects[0]
                    
                }
            }
            .onChange(of: keynoteManager.isKeynoteProcessOpen, { _, newValue in
                if newValue {
                    updateOpendKeynotes()
                }
            })
            .onChange(of: keynoteManager.opendKeynotes) { _, newValue in
                keynoteOptions = newValue
                if !newValue.isEmpty {
                    selectedkeynote = newValue[0]
                }
                updateCurrentProject()
            }
            .onChange(of: projectManager.projects) { _, newValue in
                if let projects = newValue {
                    projectOptions = projects
                    projectOptions.append(Project())
                    selectedProject = projects[0]
                }
            }
            .onChange(of: selectedkeynote, {
                updateCurrentProject()
            })
        }
    }
}

// MARK: - Methods
extension MenubarExtraView {
    private func getIsActiveKeynoteApp() {
        Task {
            let result = await appleScriptManager.runScript(.isActiveKeynoteApp)
            if case .boolResult(let isKeynoteOpen) = result {
                // logic 2
//                print(isKeynoteOpen)
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
        if keynoteManager.opendKeynotes.isEmpty {
            print("is Empty!")
        } else {
            let filtered = projectManager.projects?.filter({ project in
                project.keynoteCreation == selectedkeynote.creation
            })
            if let find = filtered {
                if !find.isEmpty {
                    print("일치하는 프로젝트: \(find[0].projectName)")
                    projectManager.current = find[0]
                    selectedProject = projectOptions.first!
                } else {
                    print("일치하는 프로젝트가 없음")
                    selectedProject = projectOptions.last!
                }
            }
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
    
    private func startPractice() {
        if !mediaManager.isRecording {
            print("녹음 시작")
            print(selectedkeynote.path)
            Task {
                await appleScriptManager.runScript(.startPresentation(fileName: selectedkeynote.path))
            }
            mediaManager.isRecording.toggle()
            isMenuPresented.toggle()
        } else {
            print("녹음 종료")
            mediaManager.isRecording.toggle()
        }
    }
    
    private func openSelectedPractice(practice: Practice) {
        projectManager.current = selectedProject
        projectManager.currentTabItem = 1
        if !projectManager.path.isEmpty {
            projectManager.path.removeLast()
        }
        // MARK: - 뷰 갱신 하는 방법으로 변경해야함.!!!
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            projectManager.path.append(practice)
        }
    }
    
    private func quitApp() {
        exit(0)
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
                openSelectedProject()
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
                if !keynoteOptions.isEmpty {
                    Picker("프로젝트", selection: $selectedkeynote) {
                        ForEach(keynoteOptions, id: \.id) { opendKeynote in
                            Text("\(opendKeynote.getFileName())").tag(opendKeynote)
                        }
                    }
                    .labelsHidden()
                } else {
                    Text("현재 열려 있는 키노트 파일이 없네여")
                }
                Text("프로젝트")
                Picker("프로젝트", selection: $selectedProject) {
                    ForEach(projectOptions, id: \.self) { project in
                        Text("\(project.projectName)").tag(project)
                    }
                }
                .labelsHidden()
            }
            Spacer()
            // 선택 된 프로젝트로 연습 하기 || 연습 그만하기
            Button {
                startPractice()
            } label: {
                let label = if !mediaManager.isRecording {
                    (text: "연습 시작하기", icon: "play.fill")
                } else {
                    (text: "연습 종료하기", icon: "stop.circle.fill")
                }
                Label(label.text, systemImage: label.icon)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
        .frame(minHeight: 32)
    }
    
    @ViewBuilder
    private var sectionPractice: some View {
        VStack(spacing: 0) {
            if !selectedProject.practices.isEmpty {
                ScrollView {
                    LazyVGrid(columns: [GridItem()], spacing: 8) {
                        ForEach(selectedProject.practices, id: \.self) { practice in
                            HStack {
                                Text("\(practice.audioPath)")
                                Spacer()
                                Button {
                                    openSelectedPractice(practice: practice)
                                } label: {
                                    Text("자세히 보기")
                                }
                            }
                            .padding()
                            .background(Color("000000").opacity(0.1))
                            .cornerRadius(5)
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
            } else {
                VStack {
                    Text("연습 이력이 없네요...")
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    @ViewBuilder
    private var footer: some View {
        // 앱 종료
        HStack {
            Spacer()
            Button {
                quitApp()
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
    @State var value: Bool = true
    return MenubarExtraView(isMenuPresented: $value)
        .environment(AppleScriptManager())
        .environment(MediaManager())
        .environment(KeynoteManager())
        .frame(maxWidth: 360, maxHeight: 480)
}
#endif
