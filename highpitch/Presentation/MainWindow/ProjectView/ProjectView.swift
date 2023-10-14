//
//  ProjectView.swift
//  highpitch
//
//  Created by yuncoffee on 10/13/23.
//

import SwiftUI

/**
 전체 연습 통계
 전체 연습 통계 UI 그리기
 프로젝트 불러오기
 특정 키노트 열기
 연습 횟수 불러오기
 연습 기간 불러오기
 평균 레벨 출력하기
 가장 높게 평가된 연습 회차 정보로 이동 버튼 기능
 평균 레벨 추이 그래프
 필러워드 그래프
 말 빠르기 그래프
 */

struct MockHuman: Hashable, Identifiable {
    var id = UUID()
    var name: String
    var ages: Int
}

struct ProjectView: View {
    @Environment(ProjectManager.self)
    private var projectManager

    @State 
    private var currentTabItem = 1 {
        didSet {
            print(currentTabItem)
        }
    }
    
    @State 
    var mocks = [
        MockHuman(name: "111", ages: 10),
        MockHuman(name: "222", ages: 20),
        MockHuman(name: "333", ages: 30)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            tabBar
            tabBarContentContainer
        }
        .onAppear {
            /// [임시] currnetTabItem을 0로 실행 후
            /// 최초 버튼 클릭 시 NavigationStackView가 무거운지 상태는 변경되지만 뷰 갱신이 안됨.
            /// 이후 한번 더 클릭 시는 뷰가 잘 갱신되긴함. 그래서 우선 1로 렌더링 후 0으로 변경 하였음.
            currentTabItem = 0
        }
    }
}

// MARK: - Views
extension ProjectView {
    
    // MARK: - tabBar
    @ViewBuilder
    private var tabBar: some View {
        let labels = ["전체 연습 통계", "연습 회차별 피드백"]
        HStack(spacing: 24) {
            ForEach(Array(labels.enumerated()), id: \.1.self) { index, label in
                Button {
                    print("Tab Click: \(index)")
                    currentTabItem = index
                } label: {
                    Text(label)
                        .padding(.top, 24)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 10)
                        .frame(maxHeight: .infinity)
                        .border(
                            currentTabItem == index
                            ? Color("AC9FFF").opacity(0.75)
                            : .clear,
                            width: 3,
                            edges: [.bottom]
                        )
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 64)
        .frame(maxWidth: .infinity , minHeight: 60, maxHeight: 60, alignment: .bottomLeading)
        .border(Color("AC9FFF").opacity(0.25), width: 1, edges: [.bottom])
    }
    
    @ViewBuilder
    private var tabBarContentContainer: some View {
        VStack {
            if currentTabItem == 0 {
                // 컨텐츠 1 - 전체 연습통계
                StatisticsTabItem()
            } else {
                // 컨텐츠 2 - 연습 회차별 피드백
                PracticesTabItem(mocks: $mocks)
            }
        }
        .border(.red, width: 2)
        .background(Color.blue)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ProjectView()
}
