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
        var sentences = data.sentences
        
        VStack {
            Text("이번 연습에서의 발화 속도")
            Text("평균 발화 속도")
            Text("빠르게 말한 비율은 nn%로 적절했어요.")
            Text("발화속도(EPM)")
            Chart {
                RectangleMark(
                    xStart: .value("", 0),
                    xEnd: .value("", sentences.count),
                    yStart: .value("", 288),
                    yEnd: .value("", 422.4)
                )
                .foregroundStyle(Color("F4F9EB").opacity(0.5))
                ForEach(sentences.sorted(by: { $0.index < $1.index })) { sentence in
                    LineMark(
                        x: .value("문장 번호", sentence.index),
                        y: .value("EPM", sentence.epmValue ?? 0)
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
            .chartXAxis {AxisMarks(values: [0, sentences.count - 1])}
            .chartYAxis {AxisMarks(position: .leading)}
            .chartYScale(domain: [
                min(288, sentences.sorted(by: { $0.epmValue ?? 0 < $1.epmValue ??
                    0 }).first!.epmValue ?? 0),
                max(422.4, sentences.sorted(by: { $0.epmValue ?? 0 < $1.epmValue ??
                    0 }).last!.epmValue ?? 0)
            ])
            
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

// #Preview {
//    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//    return SpeedAverageChart(data: $practice)
// }
