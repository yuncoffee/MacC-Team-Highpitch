//
//  UsagePercentChart.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

/**
 막대 차트
 */

import Charts
import SwiftUI

enum EnumFillerUsagePercent: CaseIterable {
    case empty
    case prev
    case current
    case toptier
    
    var color: (bar: Color, decorater: Color) {
        switch self {
        case .empty:
            (bar: Color.HPTextStyle.lighter, decorater: Color.HPTextStyle.base)
        case .prev:
            (bar: Color.HPTextStyle.lighter, decorater: Color.HPTextStyle.base)
        case .current:
            (bar: Color.HPPrimary.base, decorater: Color.HPPrimary.dark)
        case .toptier:
            (bar: Color.HPTextStyle.darker, decorater: Color.HPTextStyle.base)
        }
    }
    
    var label: String {
        switch self {
        case .empty:
            "지난 연습이 없어요\n"
        case .prev:
            "지난 연습\n습관어 사용 비율"
        case .current:
            "이번 연습\n습관어 사용 비율"
        case .toptier:
            "상위 10%\n습관어 사용 비율"
        }
    }
}

struct UsagePercentChart: View {
    @Binding
    var data: PracticeModel
    var projectManager: ProjectManager
    
    var body: some View {
        let maxHeight: CGFloat = 422
        let summary = data.summary
        VStack(alignment: .leading, spacing: 0) {
            header
                .frame(alignment: .topLeading)
            ZStack(alignment: .bottom) {
                Rectangle()
                    .frame(width: 350, height: 1)
                    .offset(y: -.HPSpacing.xlarge - .HPSpacing.xxsmall)
                    .foregroundStyle(Color.HPComponent.stroke)
                HStack(alignment: .bottom, spacing: 17) {
                    if (projectManager.current?.practices.sorted(by: { $0.creatAt < $1.creatAt }).first?.id != data.id) {
                        chartBar(
                            usagePercent: getPrevFillerRate(),
                            type: .prev,
                            maxHeight: 125
                        )
                    } else {
                        chartBar(
                            usagePercent: 1.0,
                            type: .empty,
                            maxHeight: 125
                        )
                    }
                    chartBar(
                        usagePercent: (summary.fillerWordPercentage),
                        type: .current,
                        maxHeight: 125
                    )
                    chartBar(
                        usagePercent: getTopTierFillerRate(),
                        type: .toptier,
                        maxHeight: 125
                    )
                }
                .frame(width: 349, height: 218)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
        }
        .padding(.bottom, .HPSpacing.xxlarge)
        .padding(.trailing, .HPSpacing.medium)
        .frame(
            maxWidth: .infinity,
            minHeight: maxHeight,
            maxHeight: maxHeight,
            alignment: .center
        )
    }
}

extension UsagePercentChart {
    /// 이전 습관어 비율
    private func getPrevFillerRate() -> Double {
        if let current = projectManager.current {
            return current.practices.sorted()[data.index - 1].summary.fillerWordPercentage
        }
        return -100
    }
    /// 상위 10% 습관어 비율
    private func getTopTierFillerRate() -> Double {
        var result: CGFloat
        result = 2
        
        return result
    }
}

extension UsagePercentChart {
    
    func fillerWordDifference() -> Double {
        if let current = projectManager.current {
            return data.summary.fillerWordPercentage -
            (current.practices.sorted()[data.index - 1 >= 0 ? data.index - 1 : 0].summary.fillerWordPercentage)
        }
        return -100
    }
    
    @ViewBuilder
    private var header: some View {
        let difference = fillerWordDifference()
        
        Text("습관어 사용 비율")
            .systemFont(.subTitle, weight: .bold)
            .foregroundStyle(Color.HPTextStyle.darker)
            .padding(.bottom, .HPSpacing.xxxsmall)
        if (data.index != 0 && difference != 0) {
            Group {
                Text("지난 연습 대비 습관어 사용 비율이 ")
                + Text("\(abs(difference), specifier: "%.1f")%P ")
                    .foregroundStyle(Color.HPPrimary.dark)
                    .bold()
                + Text(difference > 0 ? "늘었어요." : "감소했어요.")
                    .foregroundStyle(Color.HPPrimary.dark)
                    .bold()
            }.systemFont(.body)
                .foregroundStyle(Color.HPTextStyle.dark)
        }
        // TODO: 적절했어요 로직 추가되어야 합니다.
        Group {
            Text("이번 연습에서 습관어 사용 비율은 ")
            + Text("적절했어요.")
                .foregroundStyle(Color.HPPrimary.dark)
                .bold()
        }
        .systemFont(.body)
        .foregroundStyle(Color.HPTextStyle.dark)
        .padding(.bottom, .HPSpacing.large)
    }
    
    func getMaxPercentage() -> Double {
        let answer = max(getTopTierFillerRate(), data.summary.fillerWordPercentage)
        if let current = projectManager.current {
            if data.index != 0 {
                return max(answer, current.practices.sorted()[data.index - 1].summary.fillerWordPercentage)
            }
            return answer
        }
        return -100
    }
    
    @ViewBuilder
    func chartBar(
        usagePercent: Double,
        type: EnumFillerUsagePercent,
        maxHeight: Double
    ) -> some View {
        VStack(spacing: 0) {
            let barHeight = maxHeight * usagePercent / getMaxPercentage()
            /// decorater
            let decorater = if type == .empty {
                "?? "
            } else { String(format: "%.1f", usagePercent) }
            Text("\(decorater)%")
                .systemFont(.body)
                .foregroundStyle(type.color.decorater)
                .padding(.bottom, .HPSpacing.xxxxsmall)
            /// bar
            Rectangle()
                .frame(
                    width: 50,
                    height: barHeight
                )
                .foregroundStyle(type.color.bar)
                .clipShape(
                    .rect(
                        topLeadingRadius: 4,
                        topTrailingRadius: 4
                    )
                )
                .padding(.bottom, .HPSpacing.xsmall)
            /// label
            Text("\(type.label)")
                .systemFont(.caption, weight: .regular)
                .foregroundStyle(Color.HPTextStyle.darker)
                .multilineTextAlignment(.center)
                .fixedSize()
                .frame(height: 48)
        }
        .frame(width: 105)
    }
}
