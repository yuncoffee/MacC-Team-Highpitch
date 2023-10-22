//
//  StatisticsTabItem.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI
import Charts

struct StatisticsTabItem: View {
    @Environment(ProjectManager.self)
    private var projectManager

    @State 
    private var selectedGraph = "평균 레벨 추이"
    @State
    private var graphOptions = ["레벨", "습관어", "발화 속도"]
    @State
    private var selectedSegment = 0
    @State var isPopoverActive = false
    
    var body: some View {
        let practiceCount = projectManager.current?.practices.count
        VStack(alignment:.leading, spacing: 0) {
            if let practiceCount = practiceCount {
                if let practices = projectManager.current?.practices.sorted(by: { $0.creatAt < $1.creatAt }) {
                    let practiceDuration = "\(practices.first!.creatAt) - \(practices.last!.creatAt)"
                    VStack(alignment: .leading, spacing: 0) {
                        Text("총 \(practiceCount)번의 연습에 대한 결과예요")
                            .systemFont(.largeTitle)
                            .foregroundStyle(Color.HPTextStyle.darker)
                        Text("\(practiceDuration) 동안 연습했어요")
                            .systemFont(.body)
                            .foregroundStyle(Color.HPTextStyle.base)
                    }
                    .padding(.bottom, .HPSpacing.xsmall)
                    HStack(spacing: .HPSpacing.xxsmall) {
                        averageLevelCard
                        bestLevelPracticeCard
                    }
                    .padding(.bottom, .HPSpacing.xxsmall)
                    /// [평균 레벨 추이 ,필러워드 말빠르기] 그래프
                    averageGraph
                }
            } else {
                emptyView
            }
        }
    }
}

extension StatisticsTabItem {
    
    func getProjectLevel() -> Double {
        var answer = 0.0
        if let practices = projectManager.current?.practices {
            for practice in practices {
                answer += Double(practice.summary.level!)
            }
            answer /= Double(practices.count)
            return answer
        } else {
            return -1
        }
    }
    
    func getBestPractice() -> PracticeModel? {
        if let practices = projectManager.current?.practices.sorted(
            by: { $0.summary.level! > $1.summary.level! }) {
            let answer = practices[0]
            return answer
        } else {
            return nil
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
        let projectLevel = getProjectLevel()
        let tier = 34.description
        let MAX_LEVEL = 5.description
        /// 결과 요약
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 2) {
                    Text("총 평균 레벨")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPTextStyle.darker)
                        .frame(height: 27)
                    Button {
                        isPopoverActive.toggle()
                    } label: {
                        Label("도움말", systemImage: "questionmark.circle")
                            .systemFont(.footnote)
                            .labelStyle(.iconOnly)
                            .foregroundStyle(Color.HPGray.system400)
                            .frame(width: 20, height: 20)
                    }.sheet(isPresented: $isPopoverActive) {
                        // TODO: Image insert
                        Text("까꿍")
                            .padding(20)
                            .onTapGesture {
                                isPopoverActive.toggle()
                            }
                    }
                    .buttonStyle(.plain)
                    .offset(y: -.HPSpacing.xxxsmall)
                }
                HStack(alignment: .center, spacing: .HPSpacing.xxsmall) {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text("LV.")
                            .systemFont(.caption, weight: .semibold)
                            .foregroundStyle(Color.HPPrimary.dark)
                        Text(" \(projectLevel, specifier: "%.1f")")
                            .styledFont(.largeTitleLv)
                            .foregroundStyle(Color.HPPrimary.dark)
                        Text("/\(MAX_LEVEL)")
                            .systemFont(.caption, weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.light)
                    }
                    .frame(alignment: .bottom)
                    HStack(spacing: 0) {
                        HPStyledLabel(content: "상위 \(tier)%")
                    }
                    .frame(alignment: .center)
                }
            }
            .padding(.vertical, .HPSpacing.xsmall)
            .padding(.horizontal, .HPSpacing.medium)
            .frame(minHeight: 100, maxHeight: 100, alignment: .leading)
            .background(Color.HPGray.systemWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.HPComponent.shadowColor ,radius: 10, y: .HPSpacing.xxxxsmall)
        }
    }
    
    @ViewBuilder
    var bestLevelPracticeCard: some View {
        let bestPractice = getBestPractice()
        let MAX_LEVEL = 5.description
        /// 최고 카드
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 2) {
                HStack(spacing: 0) {
                    Text("내 최고 연습 회차는 ")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    Text("\((bestPractice?.index ?? -2) + 1)번째 연습")
                        .systemFont(.body, weight: .bold)
                        .foregroundStyle(Color.HPPrimary.base)
                    Text("이에요")
                        .systemFont(.body)
                        .foregroundStyle(Color.HPTextStyle.darker)
                }
                .frame(height: 27)
                Spacer()
                Button {
                    print("자세히보기 클릭했슴다")
                } label: {
                    Label("자세히보기", systemImage: "chevron.right")
                        .systemFont(.caption, weight: .semibold)
                        .foregroundStyle(Color.HPTextStyle.light)
                        .labelStyle(TextWithIconLabelStyle())
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            HStack(alignment: .center, spacing: .HPSpacing.xxsmall) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("LV. ")
                        .systemFont(.caption, weight: .semibold)
                        .foregroundStyle(Color.HPPrimary.dark)
                    Text(" \(bestPractice?.summary.level! ?? -1, specifier: "%.1f")")
                        .styledFont(.largeTitleLv)
                        .foregroundStyle(Color.HPPrimary.dark)
                    Text("/\(MAX_LEVEL)")
                        .systemFont(.caption, weight: .semibold)
                        .foregroundStyle(Color.HPTextStyle.light)
                }
                .frame(alignment: .bottom)
                HStack(spacing: 0) {
                    HPStyledLabel(content: "습관어 \(bestPractice?.summary.fillerWordCount ?? -1)회 • 발화 속도"
                                  + String(format: "%.1f", bestPractice?.summary.epmAverage! ?? -1) + "EPM")
                }
            }
            .frame(alignment: .center)
        }
        .padding(.vertical, .HPSpacing.xsmall)
        .padding(.horizontal, .HPSpacing.medium)
        .frame(maxWidth: .infinity, minHeight:100, maxHeight: 100, alignment: .leading)
        .background(Color.HPGray.systemWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.HPComponent.shadowColor ,radius: 10, y: 4)
    }
    
    @ViewBuilder
    var averageGraph: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 0) {
                HStack(spacing: .HPSpacing.small) {
                    Text("회차별 연습 차트")
                        .systemFont(.subTitle)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    HPSegmentedControl(selectedSegment: $selectedSegment, options: graphOptions)
                }
                Spacer()
                HPTooltip(tooltipContent: "도움말 컨텐츠")
                    .padding(.trailing, .HPSpacing.xsmall)
            }
            .frame(alignment: .top)
            graphContainer
        }
        .padding(.vertical, .HPSpacing.xsmall)
        .padding(.leading, .HPSpacing.medium)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.HPGray.systemWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.HPComponent.shadowColor ,radius: 10, y: 4)
    }
    
    // MARK: - 그래프 아이템들
    @ViewBuilder
    var graphContainer: some View {
        let practices = projectManager.current?.practices
        if let practices = practices {
            if selectedSegment == 0 {
                Chart {
                    ForEach(practices.sorted(by: { $0.index < $1.index })) { practice in
                        LineMark(
                            x: .value("연습 회차", practice.index + 1),
                            y: .value("레벨", practice.summary.level!)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.HPPrimary.light)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        PointMark(
                            x: .value("연습 회차", practice.index + 1),
                            y: .value("레벨", practice.summary.level!)
                        )
                        .foregroundStyle(Color.HPPrimary.base)
                    }
                }
                .chartScrollableAxes(.horizontal)
                .chartXVisibleDomain(length: 13)
                .chartYScale(domain: [0, 6])
                .chartXAxis {
                    AxisMarks(values: Array(stride(from: 1, to: practices.count + 2, by: 1))) { value in
                        AxisValueLabel(centered: false) {
                            Text("\(value.index + 1)회차")
                                .systemFont(.caption2, weight: .medium)
                                .foregroundStyle(Color.HPTextStyle.base)
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: Array(stride(from: 1, to: 6, by: 1))) { value in
                        AxisValueLabel(centered: false) {
                            Text("LV.\(value.index + 1)")
                                .systemFont(.caption2, weight: .medium)
                                .foregroundStyle(Color.HPTextStyle.base)
                        }
                        AxisGridLine()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            } else if selectedSegment == 1 {
                ScrollView(.horizontal) {
                    Chart {
                        ForEach(practices.sorted(by: { $0.index < $1.index })) { practice in
                            LineMark(
                                x: .value("연습 회차", practice.index + 1),
                                y: .value("레벨", practice.summary.fillerWordCount)
                            )
                            .foregroundStyle(Color.HPPrimary.base)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            } else {
                ScrollView(.horizontal) {
                    Chart {
                        ForEach(practices.sorted(by: { $0.index < $1.index })) { practice in
                            LineMark(
                                x: .value("연습 회차", practice.index + 1),
                                y: .value("레벨", practice.summary.epmAverage!)
                            )
                            .foregroundStyle(Color.HPPrimary.base)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }
}

#Preview {
    StatisticsTabItem()
        .environment(ProjectManager())
}
