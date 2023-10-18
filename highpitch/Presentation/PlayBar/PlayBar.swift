//
//  PlayBar.swift
//  highpitch
//
//  Created by musung on 10/18/23.
//

import Foundation
import SwiftUI

struct PlayBar: View {
    let audioManager: AudioRecorderManager
    @State private var isPlaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State var sliderValue:Float = 0
    var body: some View {
        VStack {
            Slider(value: Binding(get: {
               currentTime
           }, set: { newValue in
               seekAudio(to: newValue)
           }), in: 0...totalTime)
            .tint(Color.primary500)
            .frame(width: 720)
            HStack {
                Text(timeString(time: currentTime))
                    .systemFont(.caption, weight: .medium)
                Spacer()
                Text(timeString(time: totalTime))
                    .systemFont(.caption, weight: .medium)
            }
            .padding(.horizontal, 24.0)
            HStack(alignment: .center, spacing: 28) {
                goBackward
                controllButton
                goForward
            }.padding(0)
        }
        .frame(width: 800, height: 72)
        .onAppear {
            settingAudio()
        }
        .onReceive(timer, perform: { _ in
            updateProgress()
        })
    }
}
extension PlayBar {
    private func settingAudio() {
        do {
            try audioManager.registerAudio(url: audioManager.getPath(fileName: "test"))
            totalTime = audioManager.getDuration()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    private func play() {
        audioManager.play()
        isPlaying = true
    }
    private func pause() {
        audioManager.pausePlaying()
        isPlaying = false
        
    }
    private func seekAudio(to time: TimeInterval) {
        audioManager.audioPlayer?.currentTime = time
    }
    private func updateProgress() {
        guard let player = audioManager.audioPlayer else { return }
        currentTime = player.currentTime
    }
    private func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
    @ViewBuilder
    private var controllButton: some View {
        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            .font(.system(size: 20))
            .onTapGesture {
                isPlaying ? pause() : play()
            }
    }
    @ViewBuilder
    private var goForward: some View {
        Image(systemName: "goforward.10")
            .font(.system(size: 20))
            .onTapGesture {
                audioManager.playAfter(second: 3)
            }
    }
    @ViewBuilder
    private var goBackward: some View {
        Image(systemName: "gobackward.10")
            .font(.system(size: 20))
            .onTapGesture {
                audioManager.playAfter(second: -3)
            }
    }
}

#Preview {
    PlayBar(audioManager: AudioRecorderManager())
}
