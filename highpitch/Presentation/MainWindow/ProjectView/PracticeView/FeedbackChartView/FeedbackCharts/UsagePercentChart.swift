//
//  UsagePercentChart.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

/**
 막대 차트
 */

import SwiftUI
import Charts

enum EnumFillerUsagePercent: CaseIterable {
    case prev
    case current
    case toptier
    
    var color: (bar: Color, decorater: Color) {
        switch self {
        case .prev:
            (bar: Color.HPTextStyle.lighter, decorater: Color.HPTextStyle.base)
        case .current:
            (bar: Color.HPPrimary.base, decorater: Color.HPPrimary.base)
        case .toptier:
            (bar: Color.HPTextStyle.darker, decorater: Color.HPTextStyle.base)
        }
    }
    
    var label: String {
        switch self {
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
    var data: Practice
    
    var body: some View {
        let maxHeight: CGFloat = 500 / 3 * 2
        VStack(alignment: .leading, spacing: 0) {
            header
            GeometryReader { geometry in
                let maxWidth = geometry.size.width
                let barMaxHeight = geometry.size.height - 48 - 24
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .frame(width: maxWidth - .HPSpacing.xlarge * 2, height: 1)
                        .offset(y: -.HPSpacing.xlarge)
                        .foregroundStyle(Color.HPComponent.stroke)
                    HStack(alignment: .bottom, spacing: 0) {
                        Spacer()
                        chartBar(
                            usagePercent: getPrevFillerRate(),
                            type: .prev,
                            maxWidth: maxWidth, 
                            maxHeight: barMaxHeight
                        )
                        Spacer(minLength: .HPSpacing.xxxsmall)
                        chartBar(
                            usagePercent: getFillerRate() * 0.01,
                            type: .current,
                            maxWidth: maxWidth,
                            maxHeight: barMaxHeight
                        )
                        Spacer(minLength: .HPSpacing.xxxsmall)
                        chartBar(
                            usagePercent: getTopTierFillerRate(),
                            type: .toptier,
                            maxWidth: maxWidth,
                            maxHeight: barMaxHeight
                        )
                        Spacer()
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .bottom
                )
            }
        }
        .padding(.trailing, .HPSpacing.large + .HPSpacing.xxxxsmall)
        .frame(
            maxWidth: .infinity,
            minHeight: maxHeight,
            maxHeight: maxHeight,
            alignment: .topLeading
        )
    }
}

extension UsagePercentChart {
    /// 이전 습관어 비율
    private func getPrevFillerRate() -> CGFloat {
        var result: CGFloat
        result = 0.75
        
        return result
    }
    /// 상위 10% 습관어 비율
    private func getTopTierFillerRate() -> CGFloat {
        var result: CGFloat
        result = 0.02
        
        return result
    }
    // 습관어 사용 비율을 반환합니다.
    // swiftlint:disable identifier_name
    private func getFillerRate() -> Double {
        let fillerWordList = FillerWordList()
        
        // index에 맞게 습관어 사용 횟수를 확인합니다.
        var fillerCount = [Int](repeating: 0, count: fillerWordList.defaultList.count)
        var messagesArray: [[String]] = []
        for utterence in data.utterances {
            messagesArray.append(utterence.message.components(separatedBy: " "))
        }
        for messageArray in messagesArray {
            for message in messageArray {
                for index in 0..<fillerWordList.defaultList.count
                where fillerWordList.defaultList[index] == message {
                    fillerCount[index] += 1
                }
            }
        }
        // STT 결과의 모든 단어 수를 확인합니다.
        var wordSum = 0
        for messageArray in messagesArray {
            wordSum += messageArray.count
        }
        // 습관어 사용 횟수 / STT 모든 단어 수를 반환합니다.
        var ret = 0; for i in fillerCount { ret += i }
        return Double(ret) / Double(wordSum)
    }
    // swiftlint:enable identifier_name
}

extension UsagePercentChart {
    @ViewBuilder
    private var header: some View {
        // MARK: 수정 필요
        // nn%, 늘었어요, 적절했어요 로직 추가되어야 합니다.
        // 지난 연습과 상위 10% 결과 반환하는 로직 추가되어야 합니다.
        // 지난 연습과 상위 10% 결과를 바탕으로 높이를 연산하는 로직 추가되어야 합니다.
        Text("습관어 사용 비율")
            .systemFont(.subTitle)
            .foregroundStyle(Color.HPTextStyle.darker)
            .padding(.bottom, .HPSpacing.xxxsmall)
        Group {
            Text("지난 연습 대비 습관어 사용 비율이 ")
            + Text("nn% 늘었어요.")
                .foregroundStyle(Color.HPPrimary.base)
                .bold()
        }
        .systemFont(.body)
        .foregroundStyle(Color.HPTextStyle.dark)
        Group {
            Text("이번 연습에서 습관어 사용 비율은 ")
            + Text("적절했어요.")
                .foregroundStyle(Color.HPPrimary.base)
                .bold()
        }
        .systemFont(.body)
        .foregroundStyle(Color.HPTextStyle.dark)
        .padding(.bottom, .HPSpacing.large)
    }
    
    @ViewBuilder
    func chartBar(
        usagePercent: CGFloat,
        type: EnumFillerUsagePercent,
        maxWidth: CGFloat,
        maxHeight: CGFloat) -> some View {
        VStack(spacing: 0) {
            let barWidth = (maxWidth - 64 * 4) / 5
            let barHeight = maxHeight * usagePercent
            /// decorater
            let decorater = if type == .current {
                String(format: "%.4f", usagePercent * 100)
            } else { Int(usagePercent * 100).description }
            Text("\(decorater)%")
                .systemFont(.body)
                .foregroundStyle(type.color.decorater)
                .padding(.bottom, .HPSpacing.xxxxsmall)
            /// bar
            Rectangle()
                .frame(
                    width: barWidth,
                    height: barHeight
                )
                .foregroundStyle(type.color.bar)
                .clipShape(
                    .rect(
                        topLeadingRadius: 4,
                        topTrailingRadius: 4
                    )
                )
            /// label
            Text("\(type.label)")
                .systemFont(.caption, weight: .regular)
                .foregroundStyle(Color.HPTextStyle.darker)
                .multilineTextAlignment(.center)
                .fixedSize()
                .frame(height: 48)
        }
    }
}

#Preview {
    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
    return UsagePercentChart(data: $practice)
}
