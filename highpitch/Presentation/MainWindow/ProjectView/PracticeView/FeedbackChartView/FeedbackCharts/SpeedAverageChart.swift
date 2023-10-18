//
//  SpeedAverageChart.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

/**
 꺽은선 차트
 */
import SwiftUI
import Charts

struct SpeedAverageChart: View {
    @Binding
    var data: PracticeModel
    
    var body: some View {
        VStack {
            Text("이번 연습에서의 발화 속도")
            Text("평균 발화 속도")
            Text("빠르게 말한 비율은 nn%로 적절했어요.")
            Text("발화속도(EPM)")
            Chart {
                RectangleMark(
                    xStart: .value("", sentenceCnt()[0]),
                    xEnd: .value("", sentenceCnt()[1]),
                    yStart: .value("", 280),
                    yEnd: .value("", 400)
                )
                .foregroundStyle(Color("F4F9EB").opacity(0.5))
                ForEach(getEPM()) {
                    LineMark(
                        x: .value("문장 번호", $0.index),
                        y: .value("EPM", $0.EPMValue)
                    )
                    .foregroundStyle(Color.HPPrimary.base)
                }
            }
            .chartLegend(position: .top, alignment: .trailing, spacing: 10)
            .chartForegroundStyleScale([
                "적정 속도" : Color("F4F9EB"),
                "이번 연습" : Color.HPPrimary.base
            ])
            .chartXAxisLabel("내가 말한 문장", alignment: .center)
            .chartXAxis {AxisMarks(values: [0, sentenceCnt()[1] - 1])}
            .chartYAxis {AxisMarks(position: .leading)}
            .chartYScale(domain: rangeEPM())
            
            .frame(
                maxWidth: 300,
                maxHeight: 250
            )
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 500,
            maxHeight: .infinity
        )    }
}

struct EPMData: Identifiable {
    var id = UUID()
    var index: Int
    var EPMValue: Double
}

extension SpeedAverageChart {
    
    // EPM 지수를 리턴합니다.
    func getEPM() -> [EPMData] {
        // 길이가 짧은 문장을 합칩니다.
        var addedData: [Utterance] = []
        var tempString = ""
        var tempStartAt = -1
        var tempDuration = 0
        for utterence in data.utterances.sorted() {
            if (tempString != "") {
                tempString += " "
            }
            tempString += utterence.message
            if tempString.last! == "." {
                _ = tempString.popLast()
            }
            tempDuration += utterence.duration
            if tempString.count < 10 {
                if tempStartAt == -1 {
                    tempStartAt = utterence.startAt
                }
            } else {
                addedData.append(Utterance(
                    startAt: tempStartAt == -1 ? utterence.startAt : tempStartAt,
                    duration: tempDuration,
                    message: tempString
                ))
                tempString = ""
                tempStartAt = -1
                tempDuration = 0
            }
        }
        // 문장별 EPM을 저장합니다.
        var EPMCount = [Double](repeating: 0.0, count: addedData.count)
        var messagesArray: [[String]] = []
        for utterence in addedData {
            messagesArray.append(utterence.message.components(separatedBy: " "))
        }
        for sentenceNum in 0..<messagesArray.count {
            for word in messagesArray[sentenceNum] {
                EPMCount[sentenceNum] += Double(word.count)
            }
            EPMCount[sentenceNum] /= Double(addedData[sentenceNum].duration)
            EPMCount[sentenceNum] *= 60000.0
        }
        // EPMData를 따르는 결과를 반환합니다.
        var EPMResult: [EPMData] = []
        for index in 0..<EPMCount.count {
            EPMResult.append(EPMData(index: index + 1, EPMValue: EPMCount[index]))
        }
        return EPMResult
    }
    
    // EPM 구간을 리턴합니다.
    func rangeEPM() -> [Double] {
        // 길이가 짧은 문장을 합칩니다.
        var addedData: [Utterance] = []
        var tempString = ""
        var tempStartAt = -1
        var tempDuration = 0
        for utterence in data.utterances.sorted() {
            if (tempString != "") {
                tempString += " "
            }
            tempString += utterence.message
            if tempString.last! == "." {
                _ = tempString.popLast()
            }
            tempDuration += utterence.duration
            if tempString.count < 10 {
                if tempStartAt == -1 {
                    tempStartAt = utterence.startAt
                }
            } else {
                addedData.append(Utterance(
                    startAt: tempStartAt == -1 ? utterence.startAt : tempStartAt,
                    duration: tempDuration,
                    message: tempString
                ))
                tempString = ""
                tempStartAt = -1
                tempDuration = 0
            }
        }
        // 문장별 EPM을 저장합니다.
        var EPMCount = [Double](repeating: 0.0, count: addedData.count)
        var messagesArray: [[String]] = []
        for utterence in addedData {
            messagesArray.append(utterence.message.components(separatedBy: " "))
        }
        var maxValue = 0.0
        var minValue = 2000.0
        for sentenceNum in 0..<messagesArray.count {
            for word in messagesArray[sentenceNum] {
                EPMCount[sentenceNum] += Double(word.count)
            }
            EPMCount[sentenceNum] /= Double(addedData[sentenceNum].duration)
            EPMCount[sentenceNum] *= 60000.0
            maxValue = EPMCount[sentenceNum] > maxValue ? EPMCount[sentenceNum] : maxValue
            minValue = EPMCount[sentenceNum] < minValue ? EPMCount[sentenceNum] : minValue
        }
        return [minValue, maxValue < 400 ? 400 : maxValue]
    }
    
    // 총 문장 수를 리턴합니다.
    func sentenceCnt() -> [Int] {
        // 길이가 짧은 문장을 합칩니다.
        var addedData: [Utterance] = []
        var tempString = ""
        var tempStartAt = -1
        var tempDuration = 0
        for utterence in data.utterances.sorted() {
            if (tempString != "") {
                tempString += " "
            }
            tempString += utterence.message
            if tempString.last! == "." {
                _ = tempString.popLast()
            }
            tempDuration += utterence.duration
            if tempString.count < 10 {
                if tempStartAt == -1 {
                    tempStartAt = utterence.startAt
                }
            } else {
                addedData.append(Utterance(
                    startAt: tempStartAt == -1 ? utterence.startAt : tempStartAt,
                    duration: tempDuration,
                    message: tempString
                ))
                tempString = ""
                tempStartAt = -1
                tempDuration = 0
            }
        }
        return [0, addedData.count + 1]
    }
    
}

// #Preview {
//    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//    return SpeedAverageChart(data: $practice)
// }
