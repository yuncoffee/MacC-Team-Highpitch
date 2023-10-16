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
    var data: Practice
    
    var body: some View {
        VStack {
            Chart {
                BarMark(
                    x: .value("연습 종류", "이번 연습\n습관어 사용 비율"),
                    y: .value("습관어 사용 비율", getFillerRate())
                )
            }
        }
        .frame(
            maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
            minHeight: 500,
            maxHeight: .infinity
        )
    }
}

// swiftlint:disable identifier_name
extension UsagePercentChart {
    
    // MARK: 습관어 사용 비율을 리턴합니다.
    // 비율 연산 과정이 추가되어야 합니다. (습관어 사용 횟수 / ???)
    func getFillerRate() -> Double {
        let fillerWordList = FillerWordList()
        // index에 맞게 fillerword 사용 횟수를 확인합니다.
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
        var ret = 0; for i in fillerCount { ret += i }
        return Double(ret)
    }
}
// swiftlint:enable identifier_name

#Preview {
    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
    return UsagePercentChart(data: $practice)
}
