//
//  UsagePercentChart.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

/**
 막대 차트
 */

import SwiftUI
import Charts

struct UsagePercentChart: View {
    @Binding
    var data: PracticeModel
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                // MARK: 수정 필요
                // nn%, 늘었어요, 적절했어요 로직 추가되어야 합니다.
                // 지난 연습과 상위 10% 결과 반환하는 로직 추가되어야 합니다.
                // 지난 연습과 상위 10% 결과를 바탕으로 높이를 연산하는 로직 추가되어야 합니다.
                Text("습관어 사용 비율")

                Text("지난 연습 대비 습관어 사용 비율이 ")
                + Text("nn% 늘었어요.")
                    .foregroundStyle(Color("8B6DFF"))
                
                Text("이번 연습에서 습관어 사용 비율은 ")
                + Text("적절했어요.")
                    .foregroundStyle(Color("8B6DFF"))
                
                HStack(alignment: .bottom) {
                    VStack {
                        Text("15%")
                            .foregroundColor(Color("000000").opacity(0.5))
                        Rectangle()
                            .frame(width: 44, height: 88)
                            .foregroundColor(Color("000000").opacity(0.25))
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 4,
                                    topTrailingRadius: 4
                                )
                            )
                        Text("지난 연습\n습관어 사용 비율")
                            .multilineTextAlignment(.center)
                            .fixedSize()
                    }
                    VStack {
                        Text("\(getFillerRate())%")
                            .foregroundColor(Color("8B6DFF"))
                        Rectangle()
                            .frame(width: 44, height: 110)
                            .foregroundColor(Color("8B6DFF"))
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 4,
                                    topTrailingRadius: 4
                                )
                            )
                        Text("이번 연습\n습관어 사용 비율")
                            .multilineTextAlignment(.center)
                            .fixedSize()
                    }
                    VStack {
                        Text("2%")
                            .foregroundColor(Color("000000").opacity(0.85))
                        Rectangle()
                            .frame(width: 44, height: 14)
                            .foregroundColor(Color("000000").opacity(0.85))
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 4,
                                    topTrailingRadius: 4
                                )
                            )
                        Text("상위 10%\n습관어 사용 비율")
                            .multilineTextAlignment(.center)
                            .fixedSize()
                    }
                }
                .frame(height: 200)
            }
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 500,
            maxHeight: .infinity
        )
    }
}

extension UsagePercentChart {
    
    // 습관어 사용 비율을 반환합니다.
    // swiftlint:disable identifier_name
    func getFillerRate() -> Double {
        let fillerWordList = FillerWordList()
        
        // index에 맞게 습관어 사용 횟수를 확인합니다.
        var fillerCount = [Int](repeating: 0, count: fillerWordList.defaultList.count)
        var messagesArray: [[String]] = []
        for utterence in data.utterances {
            messagesArray.append(utterence.message.components(separatedBy: " "))
        }
        for messageArray in messagesArray {
            for message in messageArray {
                for index in 0..<fillerWordList.defaultList.count
                where fillerWordList.defaultList[index] == message {
                    fillerCount[index] += 1
                }
            }
        }
        // STT 결과의 모든 단어 수를 확인합니다.
        var wordSum = 0
        for messageArray in messagesArray {
            wordSum += messageArray.count
        }
        // 습관어 사용 횟수 / STT 모든 단어 수를 반환합니다.
        var ret = 0; for i in fillerCount { ret += i }
        return Double(ret) / Double(wordSum)
    }
    // swiftlint:enable identifier_name
}

// #Preview {
//    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//    return UsagePercentChart(data: $practice)
// }
