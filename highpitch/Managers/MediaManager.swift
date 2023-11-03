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
    var isPause = false
    var isPlaying = false
    
    /// 음성메모 녹음 관련 프로퍼티
    var audioRecorder: AVAudioRecorder?
    
    /// 음성메모 재생 관련 프로퍼티
    /// audioPlayer.currentTime을 통해서 음성 이동하기
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    var currentTime: TimeInterval = 0
    var fileName: String = ""
    var stopPoint: TimeInterval?
}

// MARK: - 음성메모 녹음 관련 메서드
extension MediaManager: Recordable {
    func checkMicrophonePermission() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            // 이미 권한을 얻은 경우
            print("마이크 녹음 권한이 승인되었습니다.")
            return true
        case .notDetermined:
            // 아직 사용자에게 권한을 요청하지 않은 경우
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                if granted {
                    print("마이크 녹음 권한이 승인되었습니다.")
                } else {
                    print("마이크 녹음 권한이 거부되었습니다.")
                }
            }
            return false
        case .denied, .restricted:
            // 사용자가 권한을 거부하거나 앱 사용을 제한한 경우
            print("마이크 녹음 권한이 거부되었거나 제한되었습니다.")
            return false
        }
    }
    func startRecording() {
        if isRecording {
            audioRecorder?.record()
            isPause = false
        } else {
            prepareRecording()
            audioRecorder?.record()
            isRecording = true
        }
    }
    
    func prepareRecording() {
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
        } catch {
            print("녹음 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    func pauseRecording() {
        audioRecorder?.pause()
        isPause = true
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
extension MediaManager: AudioPlayable {
    func registerAudio(url: URL) throws {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            // MARK: 음성 녹음 및 재생 볼륨 설정
            audioPlayer?.volume = 10.0
            audioPlayer?.delegate = self
        } catch {
            print("재생 중 오류 발생: \(error.localizedDescription)")
        }
    }
    func play() {
        audioPlayer?.play()
        isPlaying = true
        if !(timer?.isValid ?? false) {
            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                self.currentTime = self.audioPlayer?.currentTime ?? 0
            }
        }
    }
    func playAt(atTime: Double) {
        let offset = atTime/1000
        audioPlayer?.currentTime = offset
        currentTime = offset
    }
    ///
    func playAfter(second: Double) {
        audioPlayer?.currentTime = second + (audioPlayer?.currentTime ?? 0)
    }
    ///
    func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
        timer?.invalidate()
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        isPlaying = false
        timer?.invalidate()
    }
    
    func resumePlaying() {
        audioPlayer?.play()
        isPlaying = true
    }
    func getDuration() -> Double {
        return audioPlayer?.duration ?? 0
    }
    func getState() -> Bool {
        return audioPlayer?.isPlaying ?? false
    }
    func setCurrentTime(time: TimeInterval) {
        audioPlayer?.currentTime = time
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
}

// MARK: Date.now()를 기준으로 YYYYMMDDHHMMSS.m4a 형식의 String으로 변환
extension MediaManager {
    func currentDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter.string(from: Date())
    }
}
protocol Recordable {
    func startRecording()
    func stopRecording()
}
protocol AudioPlayable {
    var isPlaying: Bool { get set }
    var currentTime: TimeInterval { get set }
    func registerAudio(url: URL) throws
    func play()
    func playAfter(second: Double)
    func stopPlaying()
    func pausePlaying()
    func getState() -> Bool
    func setCurrentTime(time: TimeInterval)
    func getDuration() -> Double
}
