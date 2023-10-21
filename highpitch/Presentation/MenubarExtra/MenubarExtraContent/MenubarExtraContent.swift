//
//  MenubarExtraContent.swift
//  highpitch
//
//  Created by yuncoffee on 10/19/23.
//

import SwiftUI
import SwiftData

struct MenubarExtraContent: View {
    @Environment(AppleScriptManager.self)
    private var appleScriptManager
    @Environment(MediaManager.self)
    private var mediaManager
    @Environment(ProjectManager.self)
    private var projectManager
    
    @Binding
    var selectedProject: ProjectModel
    
    @Binding
    var selectedKeynote: OpendKeynote
    
    @Binding
    var keynoteOptions: [OpendKeynote]
    
    @Binding
    var isMenuPresented: Bool
    
    @Query(sort: \ProjectModel.creatAt)
    var projectModels: [ProjectModel]
    
    @State
    private var isDetilsActive = false
    
    @State
    private var selectedKeynoteName = "음성으로만 연습하기"
    
    @State
    private var keynoteNameOptions: [String] = ["음성으로만 연습하기"]
    
    @State
    private var selectedProjectName = "새 프로젝트로 생성"
    
    @State
    private var projectNameOptions: [String] = ["새 프로젝트로 생성"]
    
    var body: some View {
        VStack(spacing: 0) {
            sectionProject
            sectionPractice
        }
        .onAppear {
            projectNameOptions.append(contentsOf: projectModels.map {$0.projectName})
            keynoteNameOptions.append(contentsOf: keynoteOptions.map {$0.getFileName()})
        }
        /// 키노트 리스트 변경
        .onChange(of: keynoteOptions) { _, newValue in
            var temp = ["음성으로만 연습하기"]
            temp.append(contentsOf: newValue.map {$0.getFileName()})
            keynoteNameOptions = temp
        }
        /// 키노트 변경
        .onChange(of: selectedKeynoteName) { _, newValue in
            if newValue == "음성으로만 연습하기" {
                return
            }
            let filtered = keynoteOptions.filter {$0.getFileName() == newValue}
            selectedKeynote = filtered[0]
        }
        /// 프로젝트 모델 변경
        .onChange(of: projectModels) { _, newValue in
            var temp = ["새 프로젝트로 생성"]
            temp.append(contentsOf: newValue.map {$0.projectName})
            projectNameOptions = temp
        }
        /// 프로젝트 변경
        .onChange(of: selectedProjectName) { _, newValue in
            if newValue == "새 프로젝트로 생성" {
                return
            }
            let filtered = projectModels.filter {$0.projectName == newValue}
            selectedProject = filtered[0]
        }
    }
}

extension MenubarExtraContent {
    @ViewBuilder
    private var sectionProject: some View {
        // 프로젝트의 연습 목록
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("파일 설정")
                    .systemFont(.caption, weight: .semibold)
                    .foregroundStyle(Color.HPTextStyle.dark)
                Spacer()
                Button {
                    withAnimation {
                        isDetilsActive.toggle()
                    }
                } label: {
                    Label(isDetilsActive ? "닫기" : "열기", systemImage: "chevron.right")
                        .labelStyle(.iconOnly)
                        .systemFont(.body)
                        .foregroundStyle(Color.HPGray.system600)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, .HPSpacing.xxsmall)
            .padding(.horizontal, .HPSpacing.small)
            .frame(maxHeight: 45)
            .border(.HPComponent.stroke, width: isDetilsActive ? 1 : 0, edges: [.bottom])
            // 현재 선택 된 프로젝트 정보 출력 출력
            /// 키노트가 열려있는 경우,
            if isDetilsActive {
                VStack(spacing: .HPSpacing.xsmall) {
                    HStack {
                        Text("발표 연습을 진행 할 키노트")
                            .systemFont(.caption2, weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.darker)
                        Spacer()
                        if !keynoteOptions.isEmpty {
                            HPMenu(selected: $selectedKeynoteName, options: $keynoteNameOptions)
                        } else {
                            Text("음성으로만 연습할래요?")
                        }
                    }
                    HStack {
                        Text("해당 연습을 저장할 프로젝트")
                        Spacer()
                        HPMenu(selected: $selectedProjectName, options: $projectNameOptions)
                    }
//                    VStack(alignment: .leading) {
//                        Picker("프로젝트", selection: $selectedProject) {
//                            ForEach(projectModels, id: \.self) { project in
//                                Text("\(project.projectName)").tag(project)
//                            }
//                        }
//                        .labelsHidden()
//                    }
                }
                .padding(.top, .HPSpacing.xxxsmall)
                .padding(.bottom, .HPSpacing.xsmall)
                .padding(.horizontal, .HPSpacing.small)
                .frame(maxHeight: .infinity)
            }
        }
        .frame(height: isDetilsActive ? 133 : 45, alignment: .topLeading)
        .border(.HPComponent.stroke, width: 1, edges: [.bottom])
        .clipped()
    }
    
    @ViewBuilder
    private var sectionPractice: some View {
        VStack(spacing: 0) {
            if !selectedProject.practices.isEmpty {
                ScrollView {
                    LazyVGrid(columns: [GridItem()], spacing: 8) {
                        ForEach(selectedProject.practices, id: \.self) { practice in
                            HStack {
                                Text(practice.practiceName)
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
}

extension MenubarExtraContent {
    private func openSelectedPractice(practice: PracticeModel) {
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
}

#Preview {
    @State
    var selectedKeynote: OpendKeynote = OpendKeynote()
    @State
    var keynoteOptions: [OpendKeynote] = []
    
    @State
    var isMenuPresented: Bool = true

    @State
    var selectedProject: ProjectModel = ProjectModel(
        projectName: "d",
        creatAt: "d",
        keynoteCreation: "dd"
    )
    
    return MenubarExtraContent(
        selectedProject: $selectedProject, 
        selectedKeynote: $selectedKeynote,
        keynoteOptions: $keynoteOptions,
        isMenuPresented: $isMenuPresented)
}
