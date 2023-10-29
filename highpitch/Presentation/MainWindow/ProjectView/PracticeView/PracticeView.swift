//
//  PracticeView.swift
//  highpitch
//
//  Created by yuncoffee on 10/13/23.
//

import SwiftUI
import AVKit

/**
 연습 회차별 피드백
 연습 회차별 피드백 UI 그리기
 연습리스트 불러오기
 연습 날짜 출력
 소요시간 출력
 레벨/점수 출력
 자세히 보기 버튼 구현
 편집 기능 구현
 삭제 기능
 
 특정 회차 연습 UI 그리기
 특정 연습 날짜+요일+시간(초까지) 출력
 지난 포즈필러 대비 이번 포즈필러 비율 계산 및 출력
 지난 포즈필러비율 출력
 상위 10% 필러워드비율 출력
 3회 이상 반복된 필러워드 분류 후 출력
 필러워드 상세보기에서의 데이터 출력
 말 빠르게 말하기 비율 출력
 빠르기에 대한 평가 택스트 출력
 이전 말 빠르기 데이터 그래프로 출력
 이번 말 빠르기 데이터 그래프로 출력
 그래프 클릭 시 재생 구간 이동 (재생시 그 구간부터 계속 재생)
 
 내 발표 다시보기
 발표 대본 STT로 된거 출력
 재생되고 있는 구간 표시
 필러워드 표시
 말 빠르기 구간 표시
 
 음성 불러오기 기능
 재생바 기능 구현 (드래그 및 재생 시 이동)
 재생 버튼 구현
 일시정지 버튼 구형
 10초 앞으로 구현
 10초 뒤로 구현
 */

struct PracticeView: View {
    @Environment(ProjectManager.self)
    private var projectManager
    @Environment(MediaManager.self)
    private var mediaManager
    
    @State
    var practice: PracticeModel
    
    var body: some View {
        @Bindable var mediaManager = mediaManager
        VStack(spacing: 0) {
            /// 연습 메타데이터(연습 횟수, 연습일)
            let title = practice.practiceName.description
            let date = Date().createAtToYMD(input: practice.creatAt.description) +
            " | " + Date().createAtToHMS(input: practice.creatAt.description)
            HPTopToolbar(title: title, subTitle: date)
            ZStack(alignment: .bottom) {
                practiceContentsContainer
                /// 오디오 컨트롤 뷰
                if let audioPath = practice.audioPath {
                    AudioControllerView(audioPlayer: mediaManager, audioPath: audioPath) { time in
                        mediaManager.currentTime = time
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.HPGray.systemWhite)
        .ignoresSafeArea()
        .onAppear {
            practice.utterances.sort { $0.startAt < $1.startAt }
            if !practice.isVisited {
                practice.isVisited = true
            }
        }
    }
}

extension PracticeView {
    @ViewBuilder
    private var practiceContentsContainer: some View {
        HStack(spacing: 0) {
            /// 피드백 뷰
            FeedbackChartView(
                practice: $practice,
                projectManager: projectManager
            )
            /// 스크립트 뷰
            ScriptView(
                sentences: practice.sentences.sorted(by: { $0.index < $1.index }),
                words: practice.words.sorted(by: { $0.index < $1.index })
            )
        }
        .padding(.top, .HPSpacing.small)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//extension PracticeView {
//    private func updateProgress() {
//        guard let player = mediaManager.audioPlayer else { return }
//        mediaManager.currentTime = player.currentTime
//    }
//}

// #Preview {
//    @State
//    var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//
//    return PracticeView(practice: practice)
// }
