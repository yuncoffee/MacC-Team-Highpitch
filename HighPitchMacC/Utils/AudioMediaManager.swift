//
//  AudioMediaManager.swift
//  HighPitchMacC
//
//  Created by yuncoffee on 10/9/23.
//

import Foundation
import AVFoundation
import Observation

@Observable
final class AudioMediaManager {
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    var isRecording : Bool = false
    var audioSource: URL?
}

extension AudioMediaManager {
    public func startRecording(title: String) {
        if isRecording {
            startMonitoring()
        }
        else {
            let dirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(title, isDirectory: true)
            print(dirPath)
            // 사용자의 문서 디렉토리에 JSON 파일을 저장
            do {
                /// 생성할 폴더가 이미 만들어져 있는지 확인
                if !FileManager.default.fileExists(atPath: dirPath.path) {
                    /// 만들어져있지 않다면 폴더 생성
                    print("HHHH")
                    try FileManager.default.createDirectory(
                        atPath: dirPath.path,
                        withIntermediateDirectories: false,
                        attributes: nil)
                }
            } catch {
                print("create folder error. do something, \(error)")
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd'at'HH-mm-ss"
            
            let fileName = dirPath.appendingPathComponent(
                "\(dateFormatter.string(from: Date())).m4a",
                conformingTo: .mpeg4Audio)
            audioSource = fileName
            // recoder 세팅 (내부 녹음 품질을 정함)
            let recorderSettings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                guard let filePath = audioSource else {return}
                // url을 통해서 기록
                audioRecorder = try AVAudioRecorder(url: filePath, settings: recorderSettings)
                // 오디오 파일 생성 및 준비
                audioRecorder?.prepareToRecord()
                startMonitoring()
            } catch {
                print("Failed to Setup the Recording")
            }
        }
    }
    
    public func stopRecording() {
        // 녹음 중지
        audioRecorder?.stop()
        isRecording = false
        audioRecorder = nil
    }
    
    public func playRecording() {
        guard let filePath = audioSource else {return}
        print(filePath)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: filePath)
            audioPlayer?.volume = 5.0
            audioPlayer?.play()
        } catch {
            print("faild to play file")
        }
    }
    
    private func startMonitoring() {
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.record()
        isRecording = true
    }
}
