//
//  MediaStore.swift
//  highpitch
//
//  Created by yuncoffee on 10/11/23.
//

import Foundation
import AVFoundation
import Combine

enum AudioError: Error {
    case audioNotFoundErr
}

@Observable
/// 미디어 입력, 출력 역할을 담당하는 매니저 클래스
final class MediaManager: NSObject, AVAudioPlayerDelegate {
    /// 샘플 코드
    var keynoteIsOpen = true
    
    /// 음성 녹음 진행 중인 여부 확인용
    var isRecording = false
    
    var isPlaying = false
    
    //
    /// 음성메모 녹음 관련 프로퍼티
    var audioRecorder: AVAudioRecorder?
    
    /// 음성메모 재생 관련 프로퍼티
    /// audioPlayer.currentTime을 통해서 음성 이동하기
    var audioPlayer: AVAudioPlayer?
    
    var fileName: String = ""
    
    var currentTime: TimeInterval = 0.0
    
    var stopPoint: TimeInterval?
    var timerCount: Double = 0.1
    var timer = Timer.publish(every: 0.1, on: .main, in: .common)
    var connectedTimer: Cancellable?
}

// MARK: - 음성메모 녹음 관련 메서드
extension MediaManager {
    func startRecording() {
        // MARK: 파일 이름 전략은 -> YYYYMMDDHHMMSS.m4a
        let fileURL = getPath(fileName: fileName)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("녹음 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// MARK: - 음성메모 재생 관련 메서드
extension MediaManager {
    func registerAudio(url: URL) throws {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
        } catch {
            print("재생 중 오류 발생: \(error.localizedDescription)")
        }
    }
    func play() {
        audioPlayer?.play()
        isPlaying = true
    }
    func playAt(atTime: Double) {
        let offset = atTime/1000
        audioPlayer?.currentTime = offset
    }
    ///
    func playAfter(second: Double) {
        audioPlayer?.currentTime = second + (audioPlayer?.currentTime ?? 0)
    }
    ///
    func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func resumePlaying() {
        audioPlayer?.play()
        isPlaying = true
    }
    func getPath(fileName: String) -> URL {
        let dataPath = getDocumentsDirectory()
            .appendingPathComponent("HighPitch")
            .appendingPathComponent("Audio")
        do {
            try FileManager.default
                .createDirectory(at: dataPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating directory: \(error.localizedDescription)")
        }
        return dataPath.appendingPathComponent(fileName + ".m4a")
    }
    func getDuration() -> Double {
        return audioPlayer?.duration ?? 0
    }
}
