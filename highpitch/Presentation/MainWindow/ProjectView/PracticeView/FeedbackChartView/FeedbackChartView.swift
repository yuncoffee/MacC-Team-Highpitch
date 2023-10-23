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
    @State
    var projectManager: ProjectManager
    @State
    var isPopoverActive = false
    
    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: .HPSpacing.xxxxsmall) {
                        Text("이번 연습에서 사용한 습관어")
                            .systemFont(.title)
                            .foregroundStyle(Color.HPTextStyle.darker)
                        Button {
                            isPopoverActive.toggle()
                        } label: {
                            Label("도움말", systemImage: "questionmark.circle")
                                .systemFont(.footnote)
                                .labelStyle(.iconOnly)
                                .foregroundStyle(Color.HPGray.system400)
                                .frame(width: 20, height: 20)
                        }.sheet(isPresented: $isPopoverActive) {
                            VStack(alignment: .leading, spacing: .HPSpacing.small) {
                                VStack(alignment: .leading, spacing: .HPSpacing.xxxsmall) {
                                    Text("발화 속도(EPM)란?")
                                        .systemFont(.footnote, weight: .bold)
                                        .foregroundStyle(Color.HPPrimary.base)
                                        .padding(.bottom, .HPSpacing.xxxsmall)
                                    // swiftlint: disable line_length
                                    Text("하이피치에서는 EPM(분 당 음절 수), 즉 한 분 동안 얼마나 많은 음절을 발음 했는지를 기준으로 발화 속도를 측정해요. 한국어의 경우는 단어의 구분이 모호할 때가 있어 단어보다 음절 수로 측정하는 것이 더 용이하기 때문에, EPM(분 당 음절 수) 기반 분석이 발화 속도를 개선하는 데에 유용한 도구로 사용될 수 있어요.")
                                        .fixedSize(horizontal: false, vertical: true)
                                        .systemFont(.caption)
                                        .foregroundStyle(Color.HPTextStyle.darker)
                                    // swiftlint: enable line_length
                                }
                                VStack(alignment: .leading, spacing: .HPSpacing.xxxsmall) {
                                    Text("왜 발화 속도가 중요한가요?")
                                        .systemFont(.footnote, weight: .bold)
                                        .foregroundStyle(Color.HPPrimary.base)
                                        .padding(.bottom, .HPSpacing.xxxsmall)
                                    Text("적절한 발화 속도는 전달력 있는 발표를 위한 필수 요소에요.\n 너무 빠른 발화는 청중의 이해를 어렵게 하고, 너무 느린 발화는 흥미를 잃게 해요.\n 하이피치는 논문 데이터에 따라 300~380EPM 을 적정 발화 속도로 추천해요.")
                                        .fixedSize(horizontal: false, vertical: true)
                                        .systemFont(.caption)
                                        .foregroundStyle(Color.HPTextStyle.darker)
                                    Text("* 개인의 발표 스타일에 따라 적정 범위를 조금은 벗어날 수 있어요. \n하지만 효과적인 발표 전달을 위해 추천 범위에서 40EPM 이상은 벗어나지 않는 걸 권장해요.")
                                        .fixedSize(horizontal: false, vertical: true)
                                        .systemFont(.caption2, weight: .medium)
                                        .foregroundStyle(Color.HPTextStyle.light)
                                }
                                VStack(alignment: .leading, spacing: .HPSpacing.xxxsmall) {
                                    Text("발화 속도는 어떻게 개선할 수 있나요?")
                                        .systemFont(.footnote, weight: .bold)
                                        .foregroundStyle(Color.HPPrimary.base)
                                        .padding(.bottom, .HPSpacing.xxxsmall)
                                    Text("1. 스크립트와 함께 연습한 음성을 자주 들어보세요. 발화 속도에 따라 내 발표가 어떻게 들리는지 판단할 수 있어요.")
                                        .fixedSize(horizontal: false, vertical: true)
                                        .systemFont(.caption)
                                        .foregroundStyle(Color.HPTextStyle.darker)
                                    Text("2. 차트에 표시 된 적정 속도 영역을 확인하고, 해당 부분의 음성을 들으며 빠르거나 느렸던 부분을 연습해보세요.")
                                        .fixedSize(horizontal: false, vertical: true)
                                        .systemFont(.caption)
                                        .foregroundStyle(Color.HPTextStyle.darker)
                                }

                            }
                            .padding(.vertical, .HPSpacing.xsmall)
                            .padding(.horizontal, .HPSpacing.small)
                            .frame(maxWidth: 520, maxHeight: 550)
                        }
                        .buttonStyle(.plain)
                        .offset(y: -2)
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .leading
                    )
                    .padding(.bottom, .HPSpacing.xsmall)
                    UsagePercentChart(
                        data: $practice,
                        projectManager: projectManager
                    )
                    UsageTopTierChart(summary: practice.summary)
                    if (practice.summary.fillerWordCount > 0) {
                        FillerWordDetail(data: $practice)
//                            .border(.red)
                            .padding(.bottom, .HPSpacing.medium)
                    }
                }
                Divider()
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: .HPSpacing.xxxxsmall) {
                        Text("이번 연습에서의 발화 속도")
                            .systemFont(.title)
                            .foregroundStyle(Color.HPTextStyle.darker)
                        HPTooltip(tooltipContent: "...")
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .leading
                    )
                    SpeedAverageChart(
                        sentences: practice.sentences,
                        practice: practice
                    )
                }
                .padding(.top, .HPSpacing.medium)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .leading
                )
                if (!practice.summary.fastSentenceIndex.isEmpty) {
                    FastSentReplay(practice: practice)
                }
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
