//
//  ScriptView.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct ScriptView: View {
    @Environment(MediaManager.self)
    private var mediaManager
    var sentences: [SentenceModel]
    var words: [WordModel]
    @State var nowSentece: Int?
    
    var body: some View {
        var width = 0.0
        var height = 0.0
        var currentSent = 0
        VStack(alignment: .leading, spacing: .HPSpacing.small) {
            HStack(alignment:.top, spacing: .HPSpacing.xxxxsmall) {
                Text("내 연습 다시보기")
                    .systemFont(.title)
                    .foregroundStyle(Color.HPTextStyle.darker)
                HPTooltip(tooltipContent: "다시보기", arrowEdge: .bottom, content: {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("내 연습 다시보기란?")
                            .systemFont(.footnote, weight: .bold)
                            .foregroundStyle(Color.HPTextStyle.darker)
                            .padding(.bottom, .HPSpacing.xxxxsmall)
                        Text("연습했던 해당 회차의 녹음본을 토대로 추출된 스크립트에요.")
                            .systemFont(.caption)
                            .foregroundStyle(Color.HPTextStyle.darker)
                        Text("스크립트 내에 보라색 표시 글씨는 내가 사용한 습관어를, 형광펜 밑줄은 빠르게 말한 구간을 나타내요.")
                            .fixedSize(horizontal: false, vertical: true)
                            .systemFont(.caption, weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.darker)
                            .padding(.bottom, .HPSpacing.xxxxsmall)
                        Text("* 스크립트에서도 듣고싶은 구간을 클릭하면 해당 부분부터 재생돼요.")
                            .systemFont(.caption2, weight: .medium)
                            .foregroundStyle(Color.HPPrimary.base)
                    }
                    .padding(.vertical, .HPSpacing.xsmall)
                    .padding(.horizontal, .HPSpacing.small)
                    .frame(maxWidth: 400, maxHeight: 145)
                })
            }
            .frame(maxHeight: 64)
            .padding(.horizontal, .HPSpacing.small)
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    ZStack(alignment: .topLeading) {
                        ForEach(words) { word in
                            Text(word.word)
                                .font(word.sentenceIndex == nowSentece ? .custom(
                                    FoundationTypoSystemFont.FontWeight.semibold.fontName,
                                    size: 20) : .custom(
                                        FoundationTypoSystemFont.FontWeight.semibold.fontName,
                                        size: 18))
                                .foregroundStyle(
                                    word.isFillerWord ?
                                    Color.HPPrimary.base : word.sentenceIndex == nowSentece ?
                                    Color.HPTextStyle.darker : Color.HPTextStyle.base)
                                .background(
                                    sentences[word.sentenceIndex].epmValue > 422.4 ?
                                    Color.HPComponent.highlight : Color.clear
                                )
                                .onTapGesture {
                                    nowSentece = word.sentenceIndex
                                    play(startAt: Double(sentences[nowSentece!].startAt), index: nowSentece!)
                                    mediaManager.isPlaying = true
                                }
                                .id(width == 0.0 ? word.sentenceIndex : -1)
                                .alignmentGuide(.leading) { item in
                                    if abs(width - item.width) > 279 || word.sentenceIndex != currentSent {
                                        width = 0.0; height -= item.height + 13
                                        currentSent = word.sentenceIndex
                                    }
                                    let result = width
                                    if word.index == words.count - 1 {
                                        width = 0
                                    } else { width -= item.width }
                                    return result
                                }
                                .alignmentGuide(.top) { _ in
                                    let result = height
                                    if word.index == words.count - 1 {
                                        height = 0
                                    }
                                    return result
                                }
                        }
                    }
                    .frame(minWidth: 279, maxWidth: 279, alignment: .topLeading)
                    .padding(.bottom, .HPSpacing.xxxlarge + .HPSpacing.xxxsmall)
                    .padding(.horizontal, .HPSpacing.medium)
                    .onChange(of: nowSentece) { _, newValue in
                        withAnimation {
                            scrollViewProxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                }
            }
            .padding(.bottom, 100)
        }
        .frame(
            minWidth:343,
            maxWidth: 343,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .border(Color.HPComponent.stroke, width: 1, edges: [.leading])
        .onChange(of: mediaManager.currentTime, { _, newValue in
            if nowSentece != nil {
                if nowSentece! < sentences.count {
                    if nowSentece != -1 {
                        if newValue > Double(sentences[nowSentece!].endAt)/1000 {
                            nowSentece! += 1
                        }
                    }
                }
            } else {
                nowSentece = 0
            }
            if mediaManager.stopPoint != nil {
                if mediaManager.currentTime > (mediaManager.stopPoint!)/1000 {
                    mediaManager.stopPoint = nil
                    nowSentece = -1
                    mediaManager.pausePlaying()
                }
            }
        })

    }
}

extension ScriptView {
    private func play(startAt: Double, index: Int) {
        mediaManager.playAt(atTime: startAt)
        mediaManager.play()
        nowSentece = index
    }
}
