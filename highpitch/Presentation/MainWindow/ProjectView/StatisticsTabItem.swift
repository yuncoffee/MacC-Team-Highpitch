//
//  StatisticsTabItem.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct StatisticsTabItem: View {
    @Environment(ProjectManager.self)
    private var projectManager

    @State 
    private var selectedGraph = "평균 레벨 추이"
    @State
    private var graphOptions = ["평균 레벨 추이", "필러워드", "말 빠르기"]
    @State
    private var selectedSegment = 0
    
    var body: some View {
        let practiceCount = Optional(1)// projectManager.current?.practices.count
        VStack(alignment:.leading) {
            if let practiceCount = practiceCount {
                let practiceDuration = "2023.01.01 ~ 2023.01.07"
                VStack(alignment: .leading, spacing: 8) {
                    Text("총 \(practiceCount)번의 연습에 대한 결과예요")
                        .systemFont(.largeTitle)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    Text("\(practiceDuration) 동안 연습했어요")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPTextStyle.base)
                }
                .padding(.bottom, .HPSpacing.xxsmall)
                HStack(spacing: .HPSpacing.xsmall) {
                    averageLevelCard
                    bestLvelPracticeCard
                }
                // TODO: - Padding
                .padding(.bottom, 18)
                /// [평균 레벨 추이 ,필러워드 말빠르기] 그래프
                averageGraph
            } else {
                emptyView
            }
        }
        .onChange(of: selectedGraph) { oldValue, newValue in
            print(newValue)
        }
    }
}

extension StatisticsTabItem {
    @ViewBuilder
    var emptyView: some View {
        VStack {
            Text("연습결과가 없습니다.")
        }
    }
    
    @ViewBuilder
    var averageLevelCard: some View {
        let projectLevel = 4.5.description
        let tier = 34.description
        let MAX_LEVEL = 5.description
        /// 결과 요약
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: .HPSpacing.xxsmall) {
                HStack(spacing: 2) {
                    Text("총 평균 레벨")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    HPTooltip(tooltipContent: "도움말 컨텐츠")
                        .offset(y: -.HPSpacing.xxxsmall)
                }
                HStack(alignment: .bottom, spacing: .HPSpacing.xxsmall) {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text("LV. ")
                            .systemFont(.body)
                            .foregroundStyle(Color.HPPrimary.base)
                        Text("\(projectLevel)")
                            .systemFont(.largeTitle, weight: .semibold)
                            .foregroundStyle(Color.HPPrimary.base)
                        Text("/\(MAX_LEVEL)")
                            .systemFont(.body)
                            .foregroundStyle(Color.HPTextStyle.light)
                    }
                    .frame(alignment: .bottom)
                    HStack(spacing: 0) {
                        HPStyledLabel(content: "상위 \(tier)%")
                    }
                }
            }
            // TODO: - Padding
            .padding(.vertical, 18)
            .padding(.leading, .HPSpacing.xxsmall * 3)
            .padding(.trailing, .HPSpacing.xxsmall)
            .frame(minHeight:96, maxHeight: 96, alignment: .leading)
            .background(Color.HPGray.systemWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.HPComponent.shadowColor ,radius: 10, y: .HPSpacing.xxxxsmall)
        }
    }
    
    @ViewBuilder
    var bestLvelPracticeCard: some View {
        let projectLevel = 4.5.description
        let practiceCount = 8.description
        let filler: String = 12.description
        let speed: String = 138.description
        let MAX_LEVEL = 5.description
        /// 최고 카드
        VStack(alignment: .leading, spacing: .HPSpacing.xxsmall) {
            HStack(spacing: 2) {
                HStack(spacing: 0) {
                    Text("내 최고 연습 회차는")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    Text("\(practiceCount)번째 연습")
                        .systemFont(.body, weight: .bold)
                        .foregroundStyle(Color.HPPrimary.base)
                    Text("이에요")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPTextStyle.darker)
                }
                Spacer()
                Button {
                    print("자세히보기 클릭했슴다")
                } label: {
                    Label("자세히보기", systemImage: "chevron.right")
                        .labelStyle(TextWithIconLabelStyle())
                }
                .buttonStyle(.plain)
            }
            HStack(alignment: .bottom, spacing: .HPSpacing.xxsmall) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("LV. ")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPPrimary.base)
                    Text("\(projectLevel)")
                        .systemFont(.largeTitle, weight: .semibold)
                        .foregroundStyle(Color.HPPrimary.base)
                    Text("/\(MAX_LEVEL)")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPTextStyle.light)
                }
                .frame(alignment: .bottom)
                HStack(spacing: 0) {
                    HPStyledLabel(content: "습관어 \(filler)회 | 발화 속도 \(speed)EPM")
                }
            }
        }
        // TODO: - Padding
        .padding(.vertical, 18)
        .padding(.leading, .HPSpacing.xxsmall * 3)
        .padding(.trailing, .HPSpacing.xxsmall)
        .frame(maxWidth: .infinity, minHeight:96, maxHeight: 96, alignment: .leading)
        .background(Color.HPGray.systemWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.HPComponent.shadowColor ,radius: 10, y: 4)
    }
    
    @ViewBuilder
    var averageGraph: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 0) {
                HPSegmentedControl(selectedSegment: $selectedSegment, options: graphOptions)
                Spacer()
                HPTooltip(tooltipContent: "도움말 컨텐츠")
            }
            .frame(alignment: .top)
            graphContainer
        }
        .padding(.vertical, .HPSpacing.xsmall)
        .padding(.leading, .HPSpacing.medium)
        .padding(.trailing, .HPSpacing.small)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.HPGray.systemWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.HPComponent.shadowColor ,radius: 10, y: 4)
    }
    
    @ViewBuilder
    var graphContainer: some View {
        if selectedSegment == 0 {
            Text("\(graphOptions[selectedSegment])")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        } else if selectedSegment == 1 {
            Text("\(graphOptions[selectedSegment])")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        } else {
            Text("\(graphOptions[selectedSegment])")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    StatisticsTabItem()
        .environment(ProjectManager())
}
