//
//  StatisticTabGraph.swift
//  highpitch
//
//  Created by 이용준의 Macbook on 10/29/23.
//

import Charts
import SwiftUI

struct StatisticTabGraph: View {
    @Environment(ProjectManager.self)
    private var projectManager
    
    @State
    private var selectedSegment = 0
    @State
    var rawSelected: Int?
    @State
    var rawSelectedRange: ClosedRange<Int>?
    
    @State
    var isActive = true {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now()) { self.isActive = true }
        }
    }
    
    var body: some View {
        let title: [String] = ["레벨", "습관어", "말 빠르기"]
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 0) {
                HStack(spacing: .HPSpacing.small) {
                    Text("회차별 연습 차트")
                        .systemFont(.subTitle)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    HPSegmentedControl(selectedSegment: $selectedSegment, options: title)
                }
                Spacer()
                averageGraphToolTip
                .padding(.trailing, .HPSpacing.xsmall)
            }
            .frame(alignment: .top)
            graphContainer
        }
        .padding(.vertical, .HPSpacing.xsmall)
        .padding(.leading, .HPSpacing.medium)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.HPComponent.Section.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.HPComponent.shadowColor ,radius: 10, y: 4)
        .onChange(of: selectedSegment) { _, _ in
            if isActive { isActive = false }
        }
    }
}

extension StatisticTabGraph {
    // MARK: - 그래프 컨테이너
    @ViewBuilder
    var graphContainer: some View {
        let practices = projectManager.current?.practices.sorted(by: { $0.creatAt < $1.creatAt })
        if let practices = practices, isActive {
            /// 그래프 종류
            let title: [String] = ["레벨", "습관어", "말 빠르기"]
            /// 그래프에 그려질 YAxis 범위
            let range: [[Double]] = [levelRange(), fillerWordRange(), epmValueRange()]
            Chart {
                /// 선 그래프
                ForEach(practices) { practice in
                    LineMark(
                        x: .value("연습 회차", practice.index + 1),
                        y: .value(
                            title[selectedSegment],
                            selectedSegment == 0
                            ? practice.summary.level
                            : selectedSegment == 1
                            ? practice.summary.fillerWordPercentage
                            : practice.summary.epmAverage)
                    )
                    .foregroundStyle(Color.HPPrimary.light)
                    .symbol(by: .value("", ""))
                    .symbolSize(113)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                }
                /// 가장 최근의 연습은 PointMark를 추가합니다.
                PointMark(
                    x: .value("연습 회차", practices.last!.index + 1),
                    y: .value(
                        title[selectedSegment],
                        selectedSegment == 0
                        ? practices.last!.summary.level
                        : selectedSegment == 1
                        ? practices.last!.summary.fillerWordPercentage
                        : practices.last!.summary.epmAverage)
                )
                .foregroundStyle(Color.HPPrimary.base)
                /// 호버 효과
                if let selected {
                    RuleMark(
                        x: .value("Selected", selected + 1)
                    )
                    /// 호버 시 점선
                    .lineStyle(StrokeStyle(lineWidth: 3, dash: [5, 10]))
                    .foregroundStyle(Color.gray.opacity(0.3))
                    .offset(yStart: -10)
                    .zIndex(0)
                    /// 호버 시 overlay
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
            /// 호버 control
            .chartXSelection(value: $rawSelected)
            .chartXSelection(range: $rawSelectedRange)
            /// chart의 scroll을 설정합니다.
            .chartScrollableAxes(.horizontal)
            .chartScrollPosition(initialX: practices.count)
            /// 화면에 13회차까지의 연습을 표출합니다.
            .chartXVisibleDomain(length: 13)
            /// y축은 최저 값과 최고 값 차이의 1/8까지 표출합니다.
            .chartYScale(domain: [
                range[selectedSegment].first! -
                (range[selectedSegment].last! - range[selectedSegment].first!) / 8,
                range[selectedSegment].last! +
                (range[selectedSegment].last! - range[selectedSegment].first!) / 8
            ])
            /// x축 값
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
            /// y축 값
            .chartYAxis {
                /// y축은 5개의 값이 나타나도록
                /// 최저 값과 최고 값 차이의 1/4 간격으로 설정합니다.
                AxisMarks(position: .leading, values: Array(stride(
                    from: range[selectedSegment].first!,
                    through: range[selectedSegment].last!,
                    by: (range[selectedSegment].last! - range[selectedSegment].first!) / 4
                ))) { value in
                    AxisValueLabel(centered: false) {
                        let fillerAxisValue =
                            Double(value.index)
                            * (range[selectedSegment].last! - range[selectedSegment].first!) / 4
                            + range[selectedSegment].first!
                        let rateAxisValue = Double(value.index)
                            * (range[selectedSegment].last! - range[selectedSegment].first!) / 4
                            + range[selectedSegment].first!
                        Text(
                            selectedSegment == 0
                            ? "LV.\(value.index + 1)"
                            : selectedSegment == 1
                            ? "\(fillerAxisValue, specifier: "%.1f")%"
                            : "\(rateAxisValue, specifier: "%.1f")EPM"
                        )
                        .systemFont(.caption2, weight: .medium)
                        .foregroundStyle(Color.HPTextStyle.base)
                        .padding(.trailing, 18)
                    }
                    AxisGridLine()
                }
            }
            .chartLegend(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
    
    // MARK: - 회차별 연습 차트 툴팁
    @ViewBuilder
    var averageGraphToolTip: some View {
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
    }
}

extension StatisticTabGraph {
    /// 호버 관련 변수
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
    
    /// 레벨 그래프에 그려질 YAxis 범위
    func levelRange() -> [Double] {
        return [1.0, 5.0]
    }
    /// 습관어 그래프에 그려질 YAxis 범위
    func fillerWordRange() -> [Double] {
        let practices = projectManager.current?.practices.sorted(
            by: { $0.summary.fillerWordPercentage < $1.summary.fillerWordPercentage }
        )
        if let practices = practices {
            if ( practices.first!.summary.fillerWordPercentage ==
                 practices.last!.summary.fillerWordPercentage) {
                return [
                    practices.first!.summary.fillerWordPercentage - 5.0,
                    practices.first!.summary.fillerWordPercentage + 5.0
                ]
            }
            return [
                practices.first!.summary.fillerWordPercentage,
                practices.last!.summary.fillerWordPercentage
            ]
        }
        return []
    }
    /// 말 빠르기 그래프에 그려질 YAxis 범위
    func epmValueRange() -> [Double] {
        let practices = projectManager.current?.practices.sorted(
            by: { $0.summary.epmAverage < $1.summary.epmAverage }
        )
        if let practices = practices {
            if ( practices.first!.summary.epmAverage ==
                 practices.last!.summary.epmAverage) {
                return [
                    practices.first!.summary.epmAverage - 25,
                    practices.first!.summary.epmAverage + 25
                ]
            }
            return [
                practices.first!.summary.epmAverage,
                practices.last!.summary.epmAverage
            ]
        }
        return []
    }
}
