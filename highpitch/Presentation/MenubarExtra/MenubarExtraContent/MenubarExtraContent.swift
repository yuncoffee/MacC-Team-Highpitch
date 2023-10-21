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
    private var selectedKeynoteName = "새 프로젝트로 생성"
    
    @State
    private var keynoteNameOptions: [String] = []
    
    var body: some View {
        VStack(spacing: 0) {
            sectionProject
            sectionPractice
        }
        .onChange(of: keynoteOptions) { _, newValue in
            keynoteNameOptions = newValue.map {$0.getFileName()}
        }
        .onChange(of: selectedKeynoteName) { _, newValue in
            let filtered = keynoteOptions.filter {$0.getFileName() == newValue}
            selectedKeynote = filtered[0]
        }
    }
}

extension MenubarExtraContent {
    @ViewBuilder
    private var sectionProject: some View {
        // 프로젝트의 연습 목록
        VStack(
            alignment: .leading,
            spacing: .HPSpacing.xsmall) {
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
            // 현재 선택 된 프로젝트 정보 출력 출력
            /// 키노트가 열려있는 경우,
            if isDetilsActive {
                HPMenu(
                    selected: $selectedKeynoteName,
                    options: $keynoteNameOptions
                )
                VStack(alignment: .leading) {
    //                Text("현재 열려있는 키노트")
                    if !keynoteOptions.isEmpty {
                        Picker("프로젝트", selection: $selectedKeynote) {
                            ForEach(keynoteOptions, id: \.id) { opendKeynote in
                                Text("\(opendKeynote.getFileName())").tag(opendKeynote)
                            }
                        }
                        .labelsHidden()
                    } else {
                        Text("현재 열려 있는 키노트 파일이 없네여")
                    }
                    Picker("프로젝트", selection: $selectedProject) {
                        ForEach(projectModels, id: \.self) { project in
                            Text("\(project.projectName)").tag(project)
                        }
                    }
                    .labelsHidden()
                }
            }
        }
        .padding(.vertical, .HPSpacing.xxsmall)
        .padding(.horizontal, .HPSpacing.small)
        .frame(height: isDetilsActive ? 133 : 45, alignment: .topLeading)
        .clipped()
        .border(.red, width: 2)
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
