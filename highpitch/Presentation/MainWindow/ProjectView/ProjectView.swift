//
//  ProjectView.swift
//  highpitch
//
//  Created by yuncoffee on 10/13/23.
//

import SwiftUI

struct ProjectView: View {
    @Environment(ProjectManager.self)
    private var projectManager

    var body: some View {
        VStack(spacing: 0) {
            tabBar
            tabBarContentContainer
        }
        .onAppear {
            projectManager.currentTabItem = 0
        }
    }
}

// MARK: - Views
extension ProjectView {
    
    // MARK: - tabBar
    @ViewBuilder
    private var tabBar: some View {
        let labels = ["전체 연습 통계", "연습 회차별 피드백"]
        HStack(spacing: .HPSpacing.small) {
            ForEach(Array(labels.enumerated()), id: \.1.self) { index, label in
                Button {
                    projectManager.currentTabItem = index
                } label: {
                    let selected = projectManager.currentTabItem == index
                    let labelForgroundColor: Color = if selected { 
                        .HPTextStyle.darkness } else { .HPTextStyle.base }
                    let decorationColor: Color = if selected { .HPSecondary.base } else { .clear }
                    Text(label)
                        .systemFont(.body)
                        .foregroundStyle(labelForgroundColor)
                        .padding(.top, .HPSpacing.small)
                        .padding(.bottom, .HPSpacing.xxxsmall)
                        .padding(.horizontal, .HPSpacing.xxxsmall)
                        .frame(maxHeight: .infinity)
                        .border(
                            decorationColor,
                            width: 3,
                            edges: [.bottom]
                        )
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, .HPSpacing.xxxlarge)
        .frame(maxWidth: .infinity , minHeight: 60, maxHeight: 60, alignment: .bottomLeading)
        .background(Color.HPGray.systemWhite)
//        .border(Color.HPPrimary.light.opacity(0.25), width: 1, edges: [.bottom])
    }
    
    @ViewBuilder
    private var tabBarContentContainer: some View {  
        VStack {
            if projectManager.currentTabItem == 0 {
                // 컨텐츠 1 - 전체 연습통계
                StatisticsTabItem()
            } else {
                // 컨텐츠 2 - 연습 회차별 피드백
                PracticesTabItem()
            }
        }
        .padding(.top, .HPSpacing.small + .HPSpacing.xxxxsmall)
        .padding(.horizontal, projectManager.currentTabItem == 0 ? .HPSpacing.xxxlarge : 0)
        .padding(.bottom, .HPSpacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    ProjectView()
        .environment(ProjectManager())
}
