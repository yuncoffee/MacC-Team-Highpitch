//
//  SlowSentReplay.swift
//  highpitch
//
//  Created by 이용준의 Macbook on 11/3/23.
//

import SwiftUI

struct SlowSentReplay: View {
    
    @Environment(MediaManager.self)
    private var mediaManager
    var practice: PracticeModel
    @State
    var isDetailActive = false
    @State
    var selectedIndex = -1
    @Environment(PracticeManager.self)
    private var practiceManager
        
    var body: some View {
        VStack(spacing: 0) {
            header
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isDetailActive.toggle()
                    }
                }
            if isDetailActive {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(
                            Array(practice.sentences.sorted(by: {$0.index < $1.index }).enumerated()),
                            id: \.1.id
                        ) { index, each in
                            if practice.summary.slowSentenceIndex.contains(each.index) {
                                FastSentReplayCell(
                                    sentenceIndex: each.index,
                                    index: index,
                                    startAt: Double(each.startAt),
                                    endAt: Double(each.endAt),
                                    sentence: each.sentence,
                                    isLast: index == practice.sentences.count - 1,
                                    selectedIndex: $selectedIndex
                                )
                                .padding(.horizontal, 2)
                            }
                        }
                    }
                }
            }
        }
        .frame(
            minWidth: 388,
            maxWidth: 388,
            minHeight: 70,
            maxHeight: 332,
            alignment: .top
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 2)
                .foregroundStyle(Color.HPComponent.stroke)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.bottom, .HPSpacing.xxxlarge + .HPSpacing.xxxsmall)
        .padding(.trailing, .HPSpacing.xxxlarge)
        .onChange(of: mediaManager.currentTime) { _, newValue in
            if mediaManager.stopPoint != nil {
                if newValue > (mediaManager.stopPoint!)/1000 {
                    mediaManager.stopPoint = nil
                    selectedIndex = -1
                    mediaManager.pausePlaying()
                }
            }
        }
    }
}

extension SlowSentReplay {
    private func play(startAt: Double, endAt: Double) {
        mediaManager.playAt(atTime: startAt)
        mediaManager.play()
        mediaManager.stopPoint = endAt
    }
}

extension SlowSentReplay {
    @ViewBuilder
    var header: some View {
        HStack {
            Text("느리게 말한 구간 듣기")
                .systemFont(.subTitle)
                .foregroundStyle(Color.HPTextStyle.darker)
            Spacer()
            Label("열기", systemImage: "chevron.right")
                .labelStyle(.iconOnly)
                .systemFont(.body)
                .foregroundStyle(Color.HPTextStyle.base)
                .rotationEffect(isDetailActive ? .degrees(90) : .zero)
        }
        .padding(.top, .HPSpacing.xsmall + .HPSpacing.xxxxsmall)
        .padding(.bottom, isDetailActive ? .HPSpacing.xsmall + .HPSpacing.xxxxsmall : 0)
        .padding(.horizontal, .HPSpacing.xsmall + .HPSpacing.xxxxsmall)
    }
}
