//
//  MenubarExtraContent.swift
//  highpitch
//
//  Created by yuncoffee on 10/19/23.
//

import SwiftUI
import SwiftData

struct MenubarExtraContent: View {
    @Environment(\.openWindow)
    private var openWindow
 
    @Environment(ProjectManager.self)
    private var projectManager
    @Environment(KeynoteManager.self)
    private var keynoteManager
    
    @Query(sort: \ProjectModel.creatAt)
    var projectModels: [ProjectModel]
    @Binding
    var selectedProject: ProjectModel?
    @Binding
    var selectedKeynote: OpendKeynote?
    @Binding
    var keynoteOptions: [OpendKeynote]

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
        }
        .onAppear {
            projectNameOptions.append(contentsOf: projectModels.map {$0.projectName})
            keynoteNameOptions.append(contentsOf: keynoteOptions.map {$0.getFileName()})
        }
        /// 선택된 키노트가 변경되었음
        .onChange(of: selectedKeynote, { _, newValue in
            if let newValue = newValue {
                selectedKeynoteName = newValue.getFileName()
            } else {
                selectedKeynoteName = "음성으로만 연습하기"
            }
        })
        /// 선택된 프로젝트가 변경되었음
        .onChange(of: selectedProject, { _, newValue in
            if let newValue = newValue {
                selectedProjectName = newValue.projectName
                if !keynoteManager.opendKeynotes.isEmpty {
                    let filtered = keynoteManager.opendKeynotes
                        .filter({ $0.creation == newValue.keynoteCreation })
                    if !filtered.isEmpty {
                        selectedKeynote = filtered[0]
                    } else {
                        selectedKeynoteName = "음성으로만 연습하기"
                    }
                }
            } else {
                selectedProjectName = "새 프로젝트로 생성"
            }
        })
        /// 키노트 리스트가 변경되었음
        .onChange(of: keynoteOptions) { _, newValue in
            var temp = ["음성으로만 연습하기"]
            temp.append(contentsOf: newValue.map {$0.getFileName()})
            keynoteNameOptions = temp
        }
        /// 프로젝트 모델이 변경되었음
        .onChange(of: projectModels) { _, newValue in
            var temp = ["새 프로젝트로 생성"]
            temp.append(contentsOf: newValue.map {$0.projectName})
            projectNameOptions = temp
        }
        /// 키노트 선택을 변경함
        .onChange(of: selectedKeynoteName) { _, newValue in
            if newValue == "음성으로만 연습하기" {
                selectedKeynote = nil
            } else {
                let filtered = keynoteOptions
                    .filter { $0.getFileName() == newValue } // 이름으로 필터링 중인데 변경해야

                if let selectedProject = selectedProject {
                    let _filtered =  filtered
                        .filter { $0.creation == selectedProject.keynoteCreation }
                    if !_filtered.isEmpty {
                        selectedKeynote = _filtered[0]
                    } else {
                        selectedProjectName = "새 프로젝트로 생성"
                    }
                    
                } else {
                    selectedKeynote = filtered[0] /// 사용자가 키노트의 이름을 동일하게 해서 만든다면.. 가장 첫번째가 선택이 됨.
                }
            }
        }
        /// 프로젝트 선택을 변경함
        .onChange(of: selectedProjectName) { _, newValue in
            if newValue == "새 프로젝트로 생성" {
                selectedProject = nil
            } else {
                let filtered = projectModels
                    .filter {$0.projectName == newValue} /// 이름으로 프로젝트 모델 서칭 (이름이 유니크해야함)

                if !filtered.isEmpty {
                    selectedProject = filtered[0]
                } else {
                    selectedProject = nil
                }
            }
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
                    .foregroundStyle(Color.HPTextStyle.base)
                Spacer()
                HPButton(type: .text, size: .large, color: .HPGray.system600) {
                    withAnimation {
                        isDetilsActive.toggle()
                    }
                } label: { type, size, color, expandable in
                    HPLabel(
                        content: (label: isDetilsActive ? "닫기" : "열기", icon: "chevron.right"),
                        type: type,
                        size: size,
                        color: color,
                        alignStyle: .iconOnly, 
                        expandable: expandable,
                        fontStyle: .system(.body)
                    )
                }
                .frame(width: ButtonSize.small.labelSize.height, height: ButtonSize.small.labelSize.height)
                .rotationEffect(isDetilsActive ? .degrees(90) : .zero)
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
                        // MARK: - 키노트옵션이 비어있을 때 처리 어떻게 할지?
                        HPMenu(selected: $selectedKeynoteName, options: $keynoteNameOptions)
                    }
                    HStack {
                        Text("해당 연습을 저장할 프로젝트")
                            .systemFont(.caption2, weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.darker)
                        Spacer()
                        HPMenu(selected: $selectedProjectName, options: $projectNameOptions)
                    }
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
}

#Preview {
    @State
    var selectedKeynote: OpendKeynote? = OpendKeynote()
    @State
    var keynoteOptions: [OpendKeynote] = []
    
    @State
    var selectedProject: ProjectModel? = ProjectModel(
        projectName: "d",
        creatAt: "d",
        keynoteCreation: "dd"
    )
    
    return MenubarExtraContent(
        selectedProject: $selectedProject,
        selectedKeynote: $selectedKeynote,
        keynoteOptions: $keynoteOptions)
}
