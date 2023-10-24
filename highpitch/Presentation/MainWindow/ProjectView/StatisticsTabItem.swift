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
    @State
    var isLevelTooltipActive = false
    @State
    var rawSelected: Int?
    @State
    var rawSelectedRange: ClosedRange<Int>?
    
    var body: some View {
        let practiceCount = projectManager.current?.practices.count
        VStack(alignment:.leading, spacing: 0) {
            if let practiceCount = practiceCount {
                if practiceCount > 0 {
                    if let practices =
                        projectManager.current?.practices.sorted(by: { $0.creatAt < $1.creatAt }) {
                        let practiceDuration =
                        "\(Date().createAtToYMD(input: practices.first!.creatAt)) - \(Date().createAtToYMD(input: practices.last!.creatAt))"
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
                answer += Double(practice.summary.level ?? 0)
            }
            answer /= Double(practices.count)
            return answer
        } else {
            return -1
        }
    }
    
    func getBestPractice() -> PracticeModel? {
        if let practices = projectManager.current?.practices.sorted(
            by: { $0.summary.level ?? 0 > $1.summary.level ?? 0 }) {
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
                    tooltipLevel
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
                    if let practices = projectManager.current?.practices.sorted() {
                        projectManager.currentTabItem = 1
                        if !projectManager.path.isEmpty {
                            projectManager.path.removeLast()
                        }
                        let bestPracticeModel = practices[bestPractice?.index ?? -1]
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            projectManager.path.append(bestPracticeModel)
                        }
                    }
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
        .onTapGesture {
            if let practices = projectManager.current?.practices.sorted() {
                projectManager.currentTabItem = 1
                if !projectManager.path.isEmpty {
                    projectManager.path.removeLast()
                }
                let bestPracticeModel = practices[bestPractice?.index ?? -1]
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    projectManager.path.append(bestPracticeModel)
                }
            }
        }
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
                HPTooltip(tooltipContent: "다시보기", arrowEdge: .top, content: {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("회차별 연습 차트란?")
                            .systemFont(.footnote, weight: .bold)
                            .foregroundStyle(Color.HPTextStyle.darker)
                            .padding(.bottom, .HPSpacing.xxxxsmall)
                        HStack(spacing: 0) {
                            Text("이 프로젝트에서 연습한 ").fontWeight(.regular)
                            + Text("모든 회차들의 레벨 변화와 습관어 사용 비율 변화, 평균 발화 속도의 추이").bold()
                            + Text("를 한 눈에 볼 수 있게 각각 차트로 나타냈어요.").fontWeight(.regular)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .systemFont(.caption, weight: .semibold)
                        .foregroundStyle(Color.HPTextStyle.darker)
                        Text("*차트의 점을 클릭하면, 해당 회차의 연습 날짜 및 시간 정보를 볼 수 있어요")
                            .systemFont(.caption2, weight: .medium)
                            .foregroundStyle(Color.HPPrimary.base)
                    }
                    .padding(.vertical, .HPSpacing.xsmall)
                    .padding(.horizontal, .HPSpacing.small)
                    .frame(maxWidth: 400, maxHeight: 145)
                })
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
    
    var selected: Int? {
        let practices = projectManager.current?.practices.sorted(by: { $0.index < $1.index })
        if let practices = practices {
            if let rawSelected {
                return practices.first(where: {
                    return ($0.index ... $0.index + 1).contains(rawSelected)
                })?.index
            } else if let selectedRange, selectedRange.lowerBound == selectedRange.upperBound {
                return selectedRange.lowerBound
            }
            return nil
        } else { return nil }
    }
    
    var selectedRange: ClosedRange<Int>? {
        let practices = projectManager.current?.practices.sorted(by: { $0.index < $1.index })
        if let practices = practices {
            if let rawSelectedRange {
                let lower = practices.first(where: {
                    return ($0.index ... $0.index + 1).contains(rawSelectedRange.lowerBound)
                })?.index
                let upper = practices.first(where: {
                    return ($0.index ... $0.index + 1).contains(rawSelectedRange.upperBound)
                })?.index
                
                if let lower, let upper {
                    return lower ... upper
                }
            }
            return nil
        } else { return nil }
    }
    
    func fillerWordRange() -> [Double] {
        let practices = projectManager.current?.practices.sorted(
            by: { $0.summary.fillerWordPercentage! < $1.summary.fillerWordPercentage! }
        )
        if let practices = practices {
            if ( practices.first!.summary.fillerWordPercentage! ==
                 practices.last!.summary.fillerWordPercentage!) {
                return [
                    practices.first!.summary.fillerWordPercentage! - 5.0,
                    practices.first!.summary.fillerWordPercentage! + 5.0
                ]
            }
            return [
                practices.first!.summary.fillerWordPercentage!,
                practices.last!.summary.fillerWordPercentage!
            ]
        }
        return []
    }
    
    func epmValueRange() -> [Double] {
        let practices = projectManager.current?.practices.sorted(
            by: { $0.summary.epmAverage! < $1.summary.epmAverage! }
        )
        if let practices = practices {
            if ( practices.first!.summary.epmAverage! ==
                 practices.last!.summary.epmAverage!) {
                return [
                    practices.first!.summary.epmAverage! - 25,
                    practices.first!.summary.epmAverage! + 25
                ]
            }
            return [
                practices.first!.summary.epmAverage!,
                practices.last!.summary.epmAverage!
            ]
        }
        return []
    }
    
    @ViewBuilder
    var graphContainer: some View {
        let practices = projectManager.current?.practices.sorted(by: { $0.index < $1.index })
        let range: [[Double]] = [[1.0, 5.0], fillerWordRange(), epmValueRange()]
        if let practices = practices {
            Chart {
                ForEach(practices) { practice in
                    if selectedSegment == 0 {
                        LineMark(
                            x: .value("연습 회차", practice.index + 1),
                            y: .value("레벨", practice.summary.level!)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.HPPrimary.light)
                        .symbol(by: .value("", ""))
                        .symbolSize(113)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                    } else if selectedSegment == 1 {
                        LineMark(
                            x: .value("연습 회차", practice.index + 1),
                            y: .value("습관어", practice.summary.fillerWordPercentage!)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.HPPrimary.light)
                        .symbol(by: .value("", ""))
                        .symbolSize(113)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                    } else {
                        LineMark(
                            x: .value("연습 회차", practice.index + 1),
                            y: .value("발화 속도", practice.summary.epmAverage!)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.HPPrimary.light)
                        .symbol(by: .value("", ""))
                        .symbolSize(113)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                    }
                }
                if selectedSegment == 0 {
                    PointMark(
                        x: .value("연습 회차", practices.last!.index + 1),
                        y: .value("레벨", practices.last!.summary.level!)
                    )
                    .foregroundStyle(Color.HPPrimary.base)
                } else if selectedSegment == 1 {
                    PointMark(
                        x: .value("연습 회차", practices.last!.index + 1),
                        y: .value("습관어", practices.last!.summary.fillerWordPercentage!)
                    )
                    .foregroundStyle(Color.HPPrimary.base)
                } else {
                    PointMark(
                        x: .value("연습 회차", practices.last!.index + 1),
                        y: .value("발화 속도", practices.last!.summary.epmAverage!)
                    )
                    .foregroundStyle(Color.HPPrimary.base)
                }
                if let selected {
                    RuleMark(
                        x: .value("Selected", selected + 1)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 3, dash: [5, 10]))
                    .foregroundStyle(Color.gray.opacity(0.3))
                    .offset(yStart: -10)
                    .zIndex(0)
                    .annotation(
                        position: .leading, spacing: 0,
                        overflowResolution: .init(
                            x: .fit(to: .chart),
                            y: .disabled
                        )
                    ) {
                        VStack(spacing: 0) {
                            Text("\(Date().createAtToYMD(input: practices[selected].creatAt))")
                                .systemFont(.caption, weight: .semibold)
                                .foregroundStyle(Color.HPTextStyle.dark)
                            Text("\(Date().createAtToHMS(input: practices[selected].creatAt))")
                                .systemFont(.caption, weight: .regular)
                                .foregroundStyle(Color.HPTextStyle.dark)
                                .zIndex(5)
                        }
                        .padding(.horizontal, .HPSpacing.xxxsmall)
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(color: .HPComponent.shadowBlackColor, radius: 8)
                        .frame(width: 90, height: 52)
                        .offset(x: 40)
                    }
                }
            }
            .chartXSelection(value: $rawSelected)
            .chartXSelection(range: $rawSelectedRange)
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 13)
            .chartYScale(domain: [
                range[selectedSegment].first! -
                (range[selectedSegment].last! - range[selectedSegment].first!) / 8,
                range[selectedSegment].last! +
                (range[selectedSegment].last! - range[selectedSegment].first!) / 8
            ])
            .chartXAxis {
                AxisMarks(values: Array(stride(from: 1, to: practices.count + 2, by: 1))) { value in
                    AxisValueLabel(centered: false) {
                        Text("\(value.index + 1)회차")
                            .offset(x: -17)
                            .systemFont(.caption2, weight: .medium)
                            .foregroundStyle(Color.HPTextStyle.base)
                            .padding(.trailing, 18)
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: Array(stride(
                    from: range[selectedSegment].first!,
                    to: range[selectedSegment].last! +
                    (range[selectedSegment].last! - range[selectedSegment].first!) / 4,
                    by: (range[selectedSegment].last! - range[selectedSegment].first!) / 4
                ))) { value in
                    AxisValueLabel(centered: false) {
                        if selectedSegment == 0 {
                            Text("LV.\(value.index + 1)")
                                .systemFont(.caption2, weight: .medium)
                                .foregroundStyle(Color.HPTextStyle.base)
                                .padding(.trailing, 18)
                        } else if selectedSegment == 1 {
                            Text("\(Double(value.index) * (range[selectedSegment].last! - range[selectedSegment].first!) / 4 + range[selectedSegment].first!, specifier: "%.1f")%")
                                .systemFont(.caption2, weight: .medium)
                                .foregroundStyle(Color.HPTextStyle.base)
                        } else {
                            Text("\(Double(value.index) * (range[selectedSegment].last! - range[selectedSegment].first!) / 4 + range[selectedSegment].first!, specifier: "%.1f")EPM")
                                .systemFont(.caption2, weight: .medium)
                                .foregroundStyle(Color.HPTextStyle.base)
                                .padding(.trailing, 18)
                        }
                    }
                    AxisGridLine()
                }
            }
            .chartLegend(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
    
    @ViewBuilder
    private var tooltipLevel: some View {
        Button {
            isLevelTooltipActive.toggle()
        } label: {
            Label("도움말", systemImage: "questionmark.circle")
                .systemFont(.footnote)
                .labelStyle(.iconOnly)
                .foregroundStyle(Color.HPGray.system400)
                .frame(width: 20, height: 20)
        }.sheet(isPresented: $isLevelTooltipActive) {
            ZStack(alignment: .topTrailing) {
                Button {
                    isLevelTooltipActive = false
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .foregroundStyle(Color.HPGray.system800)
                }
                .buttonStyle(.plain)
                .frame(width: 28, height: 28)
                .offset(x: -16, y: 16)
                VStack(alignment: .leading, spacing: .HPSpacing.small) {
                    VStack(alignment: .leading, spacing: .HPSpacing.xxxsmall) {
                        Text("총 평균 레벨이란?")
                            .systemFont(.footnote, weight: .bold)
                            .foregroundStyle(Color.HPTextStyle.darker)
                            .padding(.bottom, .HPSpacing.xxxsmall)
                        HStack(spacing: 0) {
                            Text("이 프로젝트에서 연습한 ")
                            + Text("모든 회차 레벨들의 평균").bold()
                            + Text("이예요.\n")
                            + Text("습관어를 말한 횟수가 적을수록, 발화 속도가 적정 속도일수록 레벨이 높아져요.")
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .systemFont(.caption)
                        .foregroundStyle(Color.HPTextStyle.darker)
                        Text("*상위 % 데이터는 0000명의 highpitch 이용자의 전체 진단 데이터를 토대로 제공되고 있어요")
                            .fixedSize(horizontal: false, vertical: true)
                            .systemFont(.caption2, weight: .medium)
                            .foregroundStyle(Color.HPPrimary.base)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text("습관어 LV 기준 및 분포도")
                            .systemFont(.caption, weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.darker)
                            .padding(.bottom, .HPSpacing.xxxsmall)
                        ZStack(alignment: .topTrailing) {
                            Text("(단위: %)")
                                .systemFont(.caption2)
                                .foregroundStyle(Color.HPGray.system600)
                                .offset(y: -22)
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text("LV.1").frame(maxWidth: .infinity)
                                    Text("LV.2").frame(maxWidth: .infinity)
                                    Text("LV.3").frame(maxWidth: .infinity)
                                    Text("LV.4").frame(maxWidth: .infinity)
                                    Text("LV.5").frame(maxWidth: .infinity)
                                }
                                .systemFont(.caption2, weight: .medium)
                                .foregroundStyle(Color.HPTextStyle.base)
                                .frame(maxWidth: .infinity)
                                .background(Color.HPPrimary.lightnest)
                                .border(.HPComponent.stroke, width: 1, edges: [.top, .bottom])
                                HStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        Text("0.12<x")
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                        Text("7.3%")
                                            .systemFont(.caption2, weight: .semibold)
                                            .foregroundStyle(Color.HPPrimary.light)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        Text("0.09< x ≤0.12")
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                        Text("27.7%")
                                            .systemFont(.caption2, weight: .semibold)
                                            .foregroundStyle(Color.HPPrimary.light)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        Text("0.06< x ≤0.09")
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                        Text("38.0%")
                                            .systemFont(.caption2, weight: .semibold)
                                            .foregroundStyle(Color.HPPrimary.light)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        Text("0.03< x ≤0.06")
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                        Text("18.4%")
                                            .systemFont(.caption2, weight: .semibold)
                                            .foregroundStyle(Color.HPPrimary.light)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        Text("0.00≤ x ≤0.03")
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                        Text("8.6%")
                                            .systemFont(.caption2, weight: .semibold)
                                            .foregroundStyle(Color.HPPrimary.light)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .border(.HPComponent.stroke, width: 1, edges: [.bottom])
                        }
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text("발화 속도 LV 기준 및 분포도")
                            .systemFont(.caption, weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.darker)
                            .padding(.bottom, .HPSpacing.xxxsmall)
                        ZStack(alignment: .topTrailing) {
                            Text("(단위 : EPM)")
                                .systemFont(.caption2)
                                .foregroundStyle(Color.HPGray.system600)
                                .offset(y: -22)
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text("LV.1").frame(maxWidth: .infinity)
                                    Text("LV.2").frame(maxWidth: .infinity)
                                    Text("LV.3").frame(maxWidth: .infinity)
                                    Text("LV.4").frame(maxWidth: .infinity)
                                    Text("LV.5").frame(maxWidth: .infinity)
                                }
                                .systemFont(.caption2, weight: .medium)
                                .foregroundStyle(Color.HPTextStyle.base)
                                .frame(maxWidth: .infinity)
                                .background(Color.HPPrimary.lightnest)
                                .border(.HPComponent.stroke, width: 1, edges: [.top, .bottom])
                                HStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        Text("土75≤ 오차값")
                                            .fixedSize()
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                        Text("4.6%")
                                            .systemFont(.caption2, weight: .semibold)
                                            .foregroundStyle(Color.HPPrimary.light)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        Text("土50≤ 오차값 <土75")
                                            .fixedSize()
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                        Text("28.2%")
                                            .systemFont(.caption2, weight: .semibold)
                                            .foregroundStyle(Color.HPPrimary.light)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        Text("土25≤ 오차값 <土50")
                                            .fixedSize()
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                        Text("31.3%")
                                            .systemFont(.caption2, weight: .semibold)
                                            .foregroundStyle(Color.HPPrimary.light)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        Text("오차값 <土25")
                                            .fixedSize()
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                        Text("23.6%")
                                            .systemFont(.caption2, weight: .semibold)
                                            .foregroundStyle(Color.HPPrimary.light)
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        Text("336≤ x <377.4")
                                            .fixedSize()
                                            .systemFont(.caption2)
                                            .foregroundStyle(Color.HPTextStyle.base)
                                        Text("12.3%")
                                            .systemFont(.caption2, weight: .semibold)
                                            .foregroundStyle(Color.HPPrimary.light)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, .HPSpacing.xxxxsmall)
                            .border(.HPComponent.stroke, width: 1, edges: [.bottom])
                        }
                        Text("*LV.1 ~ LV.4의 발화 속도 범위는, LV.5를 기준으로 각 LV 별 오차값 범위를 더하고 뺀 범위예요")
                            .fixedSize(horizontal: false, vertical: true)
                            .systemFont(.caption2, weight: .medium)
                            .foregroundStyle(Color.HPGray.system600)
                    }
                }
                .padding(.vertical, .HPSpacing.xsmall)
                .padding(.horizontal, .HPSpacing.small)
                .frame(maxWidth: 540, maxHeight: 420)
            }
        }
        .buttonStyle(.plain)
        .offset(y: -2)
    }
}

#Preview {
    StatisticsTabItem()
        .environment(ProjectManager())
}
