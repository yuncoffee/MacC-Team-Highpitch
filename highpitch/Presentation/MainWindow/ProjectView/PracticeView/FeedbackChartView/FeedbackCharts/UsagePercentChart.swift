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
    var practiceModel: PracticeModel
    var projectManager: ProjectManager
    
    var body: some View {
        let maxHeight: CGFloat = 422
        
        VStack(alignment: .leading, spacing: 0) {
            header
                .frame(alignment: .topLeading)
            ZStack(alignment: .bottom) {
                Rectangle()
                    .frame(width: 350, height: 1)
                    .offset(y: -.HPSpacing.xlarge - .HPSpacing.xxsmall - 1)
                    .foregroundStyle(Color.HPComponent.stroke)
                HStack(alignment: .bottom, spacing: 17) {
                    /// 지난 연습이 없다면(practice의 가장 첫 연습이라면) empty type으로
                    chartBar(
                        usagePercent:
                            projectManager.current?.practices.sorted(by: { $0.creatAt < $1.creatAt })
                            .first?.persistentModelID != practiceModel.persistentModelID
                            ? getPrevFillerRate() : 0.0,
                        type: projectManager.current?.practices.sorted(by: { $0.creatAt < $1.creatAt })
                            .first?.persistentModelID != practiceModel.persistentModelID
                            ? .prev : .empty
                    )
                    /// 이번 연습
                    chartBar(
                        usagePercent: (practiceModel.summary.fillerWordPercentage),
                        type: .current
                    )
                    /// 상위 10% 습관어 사용
                    chartBar(
                        usagePercent: 1,
                        type: .toptier
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
            alignment: .top
        )
    }
}

extension UsagePercentChart {
    /// 이전 습관어 비율
    private func getPrevFillerRate() -> Double {
        if let current = projectManager.current {
            var answer = -100.0
            var practices = current.practices.sorted(by: {$0.creatAt < $1.creatAt})
            for practice in practices {
                if practice.creatAt < practiceModel.creatAt {
                    answer = practice.summary.fillerWordPercentage
                } else { break }
            }
            return answer
        }
        return -100
    }
}

extension UsagePercentChart {
    
    @ViewBuilder
    private var header: some View {
        let difference =
        practiceModel.summary.fillerWordPercentage - getPrevFillerRate()
        
        Text("습관어 사용 비율")
            .systemFont(.subTitle, weight: .bold)
            .foregroundStyle(Color.HPTextStyle.darker)
            .padding(.bottom, .HPSpacing.xxxsmall)
        if let practices = projectManager.current?.practices.sorted() {
            if (practices.first?.persistentModelID != practiceModel.persistentModelID
                && difference != 0) {
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
        }
        Group {
            Text("이번 연습에서 습관어 사용 비율은 ")
            + Text(
                practiceModel.summary.level == 1
                ? "많은 편이에요." :
                practiceModel.summary.level >= 4
                ? "적절했어요." : "조금 많은 편이에요."
            )
            .foregroundStyle(Color.HPPrimary.dark)
            .bold()
        }
        .systemFont(.body)
        .foregroundStyle(Color.HPTextStyle.dark)
        .padding(.bottom, .HPSpacing.large)
    }
    
    @ViewBuilder
    func chartBar(
        usagePercent: Double,
        type: EnumFillerUsagePercent
    ) -> some View {
        VStack(spacing: 0) {
            let barHeight =
                125.0 * usagePercent
            / max(getPrevFillerRate(), practiceModel.summary.fillerWordPercentage, 0.1)
            /// decorater
            let decorater = if type == .empty {
                "?? "
            } else { String(format: "%.1f", usagePercent) }
            Text(type == .toptier ? "??%" : "\(decorater)%")
                .systemFont(.body)
                .foregroundStyle(type.color.decorater)
                .padding(.bottom, .HPSpacing.xxxxsmall)
            /// bar
            Rectangle()
                .frame(
                    width: 50,
                    height: type == .toptier ? 45 : barHeight
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
        .frame(width: 105, height: 222, alignment: .bottom)
    }
}
