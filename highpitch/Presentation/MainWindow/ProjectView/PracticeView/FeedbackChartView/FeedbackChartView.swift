//
//  FeedbackChartView.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct FeedbackChartView: View {
    @Binding
    var practice: PracticeModel
    
    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: .HPSpacing.xxxxsmall) {
                        Text("이번 연습에서 사용한 습관어")
                            .systemFont(.subTitle)
                            .foregroundStyle(Color.HPTextStyle.darker)
                        HPTooltip(tooltipContent: "...")
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .leading
                    )
                    UsagePercentChart(data: $practice)
                    UsageTopTierChart(data: $practice)
                    FillerWordDetail(data: $practice)
                        .padding(.bottom, .HPSpacing.medium)
                }
                Divider()
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: .HPSpacing.xxxxsmall) {
                        Text("이번 연습에서의 발화 속도")
                            .systemFont(.subTitle)
                            .foregroundStyle(Color.HPTextStyle.darker)
                        HPTooltip(tooltipContent: "...")
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .leading
                    )
                    SpeedAverageChart(
                        sentences: practice.sentences
                    )
                }
                .padding(.top, .HPSpacing.medium)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .leading
                )
                FastSentReplay(practice: practice)
            }
            .padding(.leading, .HPSpacing.medium)
            .padding(.bottom, 100)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension FeedbackChartView {
    @ViewBuilder
    private var header: some View {
        VStack(alignment: .leading, spacing: .HPSpacing.small + .HPSpacing.xxxxsmall) {
            Text("연습 요약보기")
                .systemFont(.largeTitle)
                .foregroundStyle(Color.HPTextStyle.darker)
        }
        .padding(.leading, .HPSpacing.small)
        .padding(.bottom, .HPSpacing.xsmall)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
//
// #Preview {
//    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//    return FeedbackChartView(practice: $practice)
// }
