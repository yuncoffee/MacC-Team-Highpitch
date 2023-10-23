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
                            // TODO: Image insert
                            Text("까꿍")
                                .padding(20)
                                .onTapGesture {
                                    isPopoverActive.toggle()
                                }
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
                    FastSentReplay(data: $practice)
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
