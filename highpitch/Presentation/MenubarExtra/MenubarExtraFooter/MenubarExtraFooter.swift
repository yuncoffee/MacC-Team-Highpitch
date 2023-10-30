//
//  MenubarExtraFooter.swift
//  highpitch
//
//  Created by yuncoffee on 10/29/23.
//

import SwiftUI
import SwiftData

struct MenubarExtraFooter: View {
    @Environment(\.openWindow)
    private var openWindow
    
    @Environment(ProjectManager.self)
    private var projectManager
    @Environment(MediaManager.self)
    private var mediaManager
    
    @Query(
        filter: #Predicate<PracticeModel> { $0.isVisited },
        sort: \PracticeModel.creatAt, order: .reverse)
    var visitedPractices: [PracticeModel] = []
    @Query(
        filter: #Predicate<PracticeModel> { !$0.isVisited },
        sort: \PracticeModel.creatAt,
        order: .reverse)
    var unVisitedPractices: [PracticeModel] = []
    
    @Query(
        sort: \ProjectModel.creatAt,
        order: .reverse
    )
    var projectModels: [ProjectModel]
    
    @Binding
    var selectedProject: ProjectModel?
    
    private let MAX_PRACTICE_NOTI_COUNT = 10
    
    var body: some View {
        VStack(spacing: 0) {
            sectionHeader
            sectionContent
        }
    }
}

extension MenubarExtraFooter {
    @ViewBuilder
    private var sectionHeader: some View {
        HStack {
            if checkUnVisitedPracticesCount() {
                Text("\(unVisitedPractices[..<MAX_PRACTICE_NOTI_COUNT].count)개 확인하지 않음")
                    .foregroundStyle(Color.HPTextStyle.dark)
                    .systemFont(.caption2, weight: .semibold)
            } else {
                Text("\(unVisitedPractices.count)개 확인하지 않음")
                    .foregroundStyle(Color.HPTextStyle.dark)
                    .systemFont(.caption2, weight: .semibold)
            }
            Spacer()
            HPButton(type: .text, size: .small, color: .HPPrimary.dark) {
                clearUnvisitedNotification()
            } label: { type, size, color, expandable in
                HPLabel(
                    content: ("모두 읽음으로 표시", nil),
                    type: type,
                    size: size,
                    color: color,
                    expandable: expandable,
                    fontStyle: .system(.caption2)
                )
            }
            .fixedSize()
        }
        .padding(.vertical, .HPSpacing.xxxsmall)
        .padding(.horizontal, .HPSpacing.xsmall + .HPSpacing.xxxxsmall)
        .border(.HPComponent.stroke, width: 1, edges: [.bottom])
    }
    
    @ViewBuilder
    private var sectionContent: some View {
        let practices = unVisitedPractices + visitedPractices
        if !practices.isEmpty {
            ScrollView {
                LazyVGrid(columns: [GridItem()], spacing: 0) {
                    if !checkUnVisitedPracticesCount() {
                        if practices.count > MAX_PRACTICE_NOTI_COUNT {
                            ForEach(practices[..<MAX_PRACTICE_NOTI_COUNT], id: \.self) { practice in
                                let filtered = projectModels
                                    .filter { $0.practices.contains {
                                        $0.persistentModelID == practice.persistentModelID
                                    }
                                    }
                                practiceResultCell(
                                    projectName: filtered.isEmpty
                                    ? "임시"
                                    : filtered[0].projectName,
                                    practice: practice
                                ) {
                                    openSelectedPractice(practice: practice)
                                }
                            }
                        } else {
                            ForEach(practices, id: \.self) { practice in
                                let filtered = projectModels
                                    .filter { $0.practices.contains {
                                        $0.persistentModelID == practice.persistentModelID
                                    }
                                    }
                                practiceResultCell(projectName: filtered.isEmpty
                                   ? "임시"
                                   : filtered[0].projectName,
                                   practice: practice
                                ) {
                                    openSelectedPractice(practice: practice)
                                }
                            }
                        }
                    } else {
                        ForEach(unVisitedPractices[..<MAX_PRACTICE_NOTI_COUNT], id: \.self) { practice in
                            let filtered = projectModels
                                .filter { $0.practices.contains {
                                    $0.persistentModelID == practice.persistentModelID
                                }
                                }
                            practiceResultCell(projectName: filtered.isEmpty 
                               ? "임시"
                               : filtered[0].projectName,
                               practice: practice
                            ) {
                                openSelectedPractice(practice: practice)
                            }
                        }
                    }
                }
            }
            .padding(.leading, .HPSpacing.xsmall + .HPSpacing.xxxxsmall)
        } else {
            emptyContent
        }
    }
    
    @ViewBuilder
    private func practiceResultCell(
        projectName: String,
        practice: PracticeModel,
        completion: @escaping () -> Void) -> some View {
            HPListCell(title: "\(practice.index + 1)번째 연습의 피드백이 생성되었어요") {
                HStack(spacing: 0) {
                    Text("\(projectName)")
                        .lineLimit(1)
                    Text(" • ")
                    Text("\(Date.diffNowToPractieDate(input: practice.creatAt))")
                }
            } notification: {
                Circle()
                    .foregroundStyle(practice.isVisited ? .clear : .HPRed.base)
            } button: {
                HPButton(type: .text, size: .small, color: .HPTextStyle.base) {
                    completion()
                } label: { type, size, color, expandable in
                    HPLabel(
                        content: ("확인하기", "chevron.right"),
                        type: type,
                        size: size,
                        color: color,
                        alignStyle: .textWithIcon,
                        expandable: expandable,
                        fontStyle: .system(.caption)
                    )
                }
            }
        }
    
    @ViewBuilder
    private var emptyContent: some View {
        VStack {
            Text("아직 발표 연습 이력이 없어요.")
        }
        .padding(.vertical, .HPSpacing.xxxsmall)
        .padding(.horizontal, .HPSpacing.small)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension MenubarExtraFooter {
    private func checkUnVisitedPracticesCount() -> Bool {
        unVisitedPractices.count > MAX_PRACTICE_NOTI_COUNT
    }
    
    private func clearUnvisitedNotification() {
        if unVisitedPractices.isEmpty {
            return
        } else {
            if checkUnVisitedPracticesCount() {
                unVisitedPractices[..<MAX_PRACTICE_NOTI_COUNT].forEach { $0.isVisited = true }
            } else {
                unVisitedPractices.forEach { $0.isVisited = true }
            }
        }
    }
    
    private func openSelectedPractice(practice: PracticeModel) {
        projectManager.current = selectedProject
        projectManager.currentTabItem = 1
        if !projectManager.path.isEmpty {
            projectManager.path.removeLast()
        }
        Task {
            await appendPractice(practice: practice)
            projectManager.path.append(practice)
        }
    }
    
    @MainActor
    private func appendPractice(practice: PracticeModel) async {
        await MainActor.run {
            openWindow(id: "main")
        }
    }
}

// #Preview {
//    @State
//    var selectedProject: ProjectModel? = nil
//
//    MenubarExtraFooter(selectedProject: $selectedProject)
// }
