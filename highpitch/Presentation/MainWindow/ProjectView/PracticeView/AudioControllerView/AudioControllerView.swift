//
//  AudioControllerView.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct AudioControllerView: View {
    //    let mediaManager: AudioRecorderManager
    @Environment(ProjectManager.self)
    private var projectManager
    @Environment(MediaManager.self)
    private var mediaManager
    
    @State
    private var isPlaying = false
    
    @State
    private var totalTime: TimeInterval = 0.0
    
    @State
    private var currentTime: TimeInterval = 0.0
    
    @State
    var sliderValue:Float = 0
    
    @Binding
    var practice: PracticeModel
    
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            sliderContainer
            buttonContainer
        }
        .padding(.top, .HPSpacing.xxxsmall)
        .padding(.bottom, .HPSpacing.xsmall)
        .frame(maxWidth: .infinity, minHeight: 72)
        .background(Color.HPComponent.audioControllerBackground)
        .background(.ultraThinMaterial)
        .border(.HPComponent.stroke, width: 1, edges: [.top])
        .onAppear {
            // MARK: 음성 파일 세팅
            if let filePath = practice.audioPath {
                settingAudio(filePath: filePath)
            }
        }
        .onReceive(timer, perform: { _ in
            updateProgress()
        })
    }
}

extension AudioControllerView {
    /// 음성파일 URL을 MediaManager에 등록
    private func settingAudio(filePath: URL) {
        do {
            try mediaManager.registerAudio(url: filePath)
            totalTime = mediaManager.getDuration()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    private func play() {
        mediaManager.play()
        isPlaying = true
    }
    private func pause() {
        mediaManager.pausePlaying()
        isPlaying = false
        
    }
    private func seekAudio(to time: TimeInterval) {
        mediaManager.audioPlayer?.currentTime = time
    }
    
    private func updateProgress() {
        guard let player = mediaManager.audioPlayer else { return }
        currentTime = player.currentTime
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
}

// MARK: - Views
extension AudioControllerView {
    @ViewBuilder
    private var sliderContainer: some View {
        VStack(spacing: 0) {
            Slider(value: Binding(get: {
                currentTime
            }, set: { newValue in
                seekAudio(to: newValue)
            }), in: 0...totalTime)
            .tint(Color.HPPrimary.base)
            .padding(.horizontal, .HPSpacing.large)
            HStack(spacing: 0) {
                Text(timeString(time: currentTime))
                    .systemFont(.caption2)
                    .foregroundStyle(Color.HPTextStyle.light)
                Spacer()
                Text(timeString(time: totalTime))
                    .systemFont(.caption2)
                    .foregroundStyle(Color.HPTextStyle.light)
            }
            .padding(.horizontal, .HPSpacing.small)
            .offset(y: .HPSpacing.xxxsmall)
        }
    }
    
    @ViewBuilder
    private var buttonContainer: some View {
        HStack(spacing: .HPSpacing.small + .HPSpacing.xxxxsmall) {
            goBackward
            controllButton
            goForward
        }
    }
    
    @ViewBuilder
    private var controllButton: some View {
        Button {
            isPlaying ? pause() : play()
        } label: {
            Label(
                isPlaying
                ? "멈춤"
                : "재생",
                systemImage: isPlaying
                ? "pause.fill"
                : "play.fill"
            )
            .systemFont(.largeTitle)
            .labelStyle(.iconOnly)
            .foregroundStyle(Color.HPTextStyle.base)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var goForward: some View {
        Button {
            mediaManager.playAfter(second: 10)
        } label: {
            Label("앞으로 10초",
                systemImage: "goforward.10"
            )
            .systemFont(.subTitle)
            .labelStyle(.iconOnly)
            .foregroundStyle(Color.HPTextStyle.base)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var goBackward: some View {
        Button {
            mediaManager.playAfter(second: -10)
        } label: {
            Label("뒤로 10초",
                systemImage: "gobackward.10"
            )
            .systemFont(.subTitle)
            .labelStyle(.iconOnly)
            .foregroundStyle(Color.HPTextStyle.base)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @State var practice = PracticeModel(practiceName: "", creatAt: "", utterances: [])
    return AudioControllerView(practice: $practice)
        .environment(MediaManager())
        .environment(ProjectManager())
}
