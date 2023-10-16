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
    var data: Practice
    
    var body: some View {
        VStack {
            Chart {
                ForEach(getEPM()) {
                    LineMark(
                        x: .value("문장 번호", $0.index),
                        y: .value("EPM", $0.EPMValue)
                    )
                }
            }
        }
        .frame(
            maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
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
    
    // MARK: EPM 지수를 리턴합니다.
    func getEPM() -> [EPMData] {
        // 문장별 EPM을 저장합니다.
        var EPMCount = [Double](repeating: 0.0, count: data.utterances.count)
        var messagesArray: [[String]] = []
        for utterence in data.utterances {
            messagesArray.append(utterence.message.components(separatedBy: " "))
        }
        for sentenceNum in 0..<messagesArray.count {
            for word in messagesArray[sentenceNum] {
                EPMCount[sentenceNum] += Double(word.count)
            }
            EPMCount[sentenceNum] /= Double(data.utterances[sentenceNum].duration)
            EPMCount[sentenceNum] *= 60000.0
        }
        // EPMData를 따르는 결과를 반환합니다.
        var EPMResult: [EPMData] = []
        for index in 0..<EPMCount.count {
            EPMResult.append(EPMData(index: index, EPMValue: EPMCount[index]))
        }
        return EPMResult
    }
}

#Preview {
    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
    return SpeedAverageChart(data: $practice)
}
