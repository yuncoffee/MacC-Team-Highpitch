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
    var isFillerWordTooltipActive = false
    @State
    var isSpeedTooltipActive = false
    
    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: .HPSpacing.xxxxsmall) {
                        Text("이번 연습에서 사용한 습관어")
                            .systemFont(.title)
                            .foregroundStyle(Color.HPTextStyle.darker)
                        tooltipFillerWord
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.bottom, .HPSpacing.xsmall)
                    UsagePercentChart(
                        practiceModel: $practice,
                        projectManager: projectManager
                    )
                    UsageTopTierChart(summary: practice.summary)
                    if (practice.summary.fillerWordCount > 0) {
                        FillerWordDetail(data: $practice)
//                            .border(.red)
                            .padding(.bottom, .HPSpacing.medium)
                    }
                }
                .frame(
                    maxWidth: 720,
                    maxHeight: .infinity,
                    alignment: .leading
                )
                Divider()
                    .padding(.trailing, .HPSpacing.medium)
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: .HPSpacing.xxxxsmall) {
                        Text("이번 연습에서의 말 빠르기")
                            .systemFont(.title)
                            .foregroundStyle(Color.HPTextStyle.darker)
                        tooltipSpeed
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
                    maxWidth: 720,
                    maxHeight: .infinity,
                    alignment: .leading
                )
                if (!practice.summary.fastSentenceIndex.isEmpty) {
                    FastSentReplay(practice: practice)
                }
            }
            .padding(.bottom, 100)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        }
        .padding(.leading, .HPSpacing.medium)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension FeedbackChartView {
    @ViewBuilder
    private var header: some View {
        VStack(spacing: 0) {
            Text("연습 요약보기")
                .systemFont(.largeTitle)
                .foregroundStyle(Color.HPTextStyle.darker)
        }
        .padding(.bottom, .HPSpacing.xsmall)
        .frame(maxWidth: 740, alignment: .leading)        
    }
    
    @ViewBuilder
    private var tooltipFillerWord: some View {
        Button {
            isFillerWordTooltipActive.toggle()
        } label: {
            Label("도움말", systemImage: "questionmark.circle")
                .systemFont(.footnote)
                .labelStyle(.iconOnly)
                .foregroundStyle(Color.HPGray.system400)
                .frame(width: 20, height: 20)
        }.sheet(isPresented: $isFillerWordTooltipActive) {
            ZStack(alignment: .topTrailing) {
                Button {
                    isFillerWordTooltipActive = false
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
                        Text("습관어란?")
                            .systemFont(.footnote, weight: .bold)
                            .foregroundStyle(Color.HPPrimary.base)
                            .padding(.bottom, .HPSpacing.xxxsmall)
                        HStack(spacing: 0) {
                            Text("습관어란, 발표 또는 스피치와 같은 ")
                            + Text("말을 할 때 무의식 중에 습관적으로 사용하게 되는 군말").bold()
                            + Text("을 뜻해요. (예를 들어 ‘아, 음, 그러니까, 그, 약간, 좀’ 등이 있어요.)")
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .systemFont(.caption)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    }
                    VStack(alignment: .leading, spacing: .HPSpacing.xxxsmall) {
                        Text("습관어 사용을 왜 개선해야해요?")
                            .systemFont(.caption, weight: .bold)
                            .foregroundStyle(Color.HPPrimary.base)
                            .padding(.bottom, .HPSpacing.xxxsmall)
                        HStack(spacing: 0) {
                            Text("습관어를 적절히 사용하면 괜찮지만, ")
                            + Text("습관어 사용이 너무 잦다면 청자가 듣기에 내가 말하고자 하는 이야기의 흐름이 끊기고 집중력을 흐리게 만들 수 있어요. ").bold()
                            + Text("가장 큰 문제는 ")
                            + Text("프로페셔널한 느낌을 줄 수 없어").bold()
                            + Text(" 나의 이미지를 훼손시킬 우려가 있다는 것이에요.")
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .systemFont(.caption)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    }
                    VStack(alignment: .leading, spacing: .HPSpacing.xxxsmall) {
                        Text("습관어 사용을 어떻게 개선할 수 있나요?")
                            .systemFont(.caption, weight: .bold)
                            .foregroundStyle(Color.HPPrimary.base)
                            .padding(.bottom, .HPSpacing.xxxsmall)
                        HStack {
                            Text("1. 반복적인 모니터링을 통해 내가 자주 사용하는 습관어를 확인")
                            + Text("내가 자주 사용하는 습관어를 확인").bold()
                            + Text("하고, ")
                            + Text("어떤 상황(당황할 때, 생각할 때 등)에서 주로 사용하게 되는지 파악").bold()
                            + Text("해보아요.")
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .systemFont(.caption)
                        .foregroundStyle(Color.HPTextStyle.darker)
                        HStack {
                            Text("2. 습관어를 사용하기보다 ")
                            + Text("한 템포 쉬고 말을 해도 좋아요. ").bold()
                            + Text("커뮤니케이션 전문가인 앤드류 들루겐(Andrew Dlugan)에 따르면 오히려 ")
                            + Text("‘마법의 짧은 침묵 Pause’").bold()
                            + Text("을 통해 상대가 나의 이야기를 더 잘 이해할 수 있고, 기대를 불러 일으킬 수 있으며, 강한 인상과 여운을 남길 수 있는 효과를 줄 수 있다고 해요. 어색한 습관어보다는 ")
                            + Text("1~2초 가량의 자연스러운 침묵을 활용").bold()
                            + Text("하면 더욱 더 프로페셔널하게 비춰질 거에요.")
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .systemFont(.caption)
                        .foregroundStyle(Color.HPTextStyle.darker)
                    }
                }
                .padding(.vertical, .HPSpacing.xsmall)
                .padding(.horizontal, .HPSpacing.small)
                .frame(maxWidth: 520, maxHeight: 550)
            }
            
        }
        .buttonStyle(.plain)
        .offset(y: -2)
    }
    
    @ViewBuilder
    private var tooltipSpeed: some View {
        Button {
            isSpeedTooltipActive.toggle()
        } label: {
            Label("도움말", systemImage: "questionmark.circle")
                .systemFont(.footnote)
                .labelStyle(.iconOnly)
                .foregroundStyle(Color.HPGray.system400)
                .frame(width: 20, height: 20)
        }.sheet(isPresented: $isSpeedTooltipActive) {
            ZStack(alignment: .topTrailing) {
                Button {
                    isSpeedTooltipActive = false
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
                        Text("발화 속도(EPM)란?")
                            .systemFont(.footnote, weight: .bold)
                            .foregroundStyle(Color.HPPrimary.base)
                            .padding(.bottom, .HPSpacing.xxxsmall)
                        // swiftlint: disable line_length
                        HStack(spacing: 0) {
                            Text("하이피치에서는")
                            + Text("EPM(분 당 음절 수)").bold()
                            + Text("즉 한 분")
                            + Text("동안 얼마나 많은 음절을 발음 했는지를 기준으로 발화 속도를 측정해요. 한국어의 경우는 단어의 구분이 모호할 때가 있어 단어보다 음절 수로 측정하는 것이 더 용이")
                            + Text("단어보다 음절 수로 측정하는 것이 더 용이").bold()
                            + Text("하기 때문에, EPM(분 당 음절 수) 기반 분석이 발화 속도를 개선하는 데에 유용한 도구로 사용될 수 있어요.")
                        }
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
                        HStack(spacing: 0) {
                            Text("적절한 발화 속도는 ")
                            + Text("전달력 있는 발표").bold()
                            + Text("를 위한 필수 요소에요.\n")
                            + Text("너무 빠른 발화는 청중의 이해를 어렵게 하고, 너무 느린 발화는 흥미를 잃게 해요.\n")
                            + Text("하이피치는 논문 데이터에 따라 ")
                            + Text("300~380EPM").bold()
                            + Text(" 을 적정 발화 속도로 추천해요.")
                        }
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
        }
        .buttonStyle(.plain)
        .offset(y: -2)
    }
}
//
// #Preview {
//    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//    return FeedbackChartView(practice: $practice)
// }
