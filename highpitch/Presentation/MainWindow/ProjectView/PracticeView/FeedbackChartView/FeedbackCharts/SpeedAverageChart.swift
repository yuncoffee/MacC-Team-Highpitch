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
    @State
    var sentences: [SentenceModel]
    var averageEPM: Double {
        sentences
            .map {$0.epmValue}
            .reduce(0, {acc, cur in acc + (cur ?? 0) }) 
            / Double(sentences.count)
    }
    
    var body: some View {
        VStack {
            header
            Chart {
                // MARK: 적정 구간 인디케이터
                RectangleMark(
                    xStart: .value("", 0),
                    xEnd: .value("", sentences.count - 1),
                    yStart: .value("", 288),
                    yEnd: .value("", 422.4)
                )
                .foregroundStyle(Color.HPComponent.appropriateSpeed.opacity(0.5))
                ForEach(sentences) { sentence in
                    LineMark(
                        x: .value("문장 번호", sentence.index),
                        y: .value("EPM", sentence.epmValue ?? 0)
                    )
                    .foregroundStyle(Color.HPPrimary.base)
                }
            }
            .chartLegend(position: .top, alignment: .bottom, spacing: 10)
            .chartYAxisLabel(alignment: .topLeading) {
                Text("(EPM)")
                    .systemFont(.caption)
                    .foregroundStyle(Color.HPTextStyle.dark)
            }
            .chartXAxisLabel(alignment: .trailing) {
                Text("(총 문장 수)")
                    .systemFont(.caption)
                    .foregroundStyle(Color.HPTextStyle.dark)
            }
//            .chartXAxis {AxisMarks(values: [0, sentences.count - 1])}
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisValueLabel {
                        if let value = value.as(Int.self) {
                            switch value {
                            case 0, sentences.count - 1:
                                Text("\(value)")
                                    .systemFont(.caption)
                                    .foregroundStyle(Color.HPTextStyle.base)
                            default:
                                Text(".")
                                    .systemFont(.caption)
                                    .foregroundStyle(Color.HPTextStyle.base)
                            }
                        }
                    }
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.HPGray.system200)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1, dash: [4, 2]))
                        .foregroundStyle(Color.HPGray.system200)
                    AxisValueLabel {
                        if let value = value.as(Int.self) {
                            Text("\(value)")
                                .systemFont(.caption)
                                .foregroundStyle(Color.HPTextStyle.base)
                        }
                    }
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.HPGray.system200)
                }
            }
            .chartXScale(domain: [0, sentences.count])
            .chartYScale(domain: [
                min(288, sentences.sorted(by: { $0.epmValue ?? 0 < $1.epmValue ??
                    0 }).first?.epmValue ?? 0),
                max(422.4, sentences.sorted(by: { $0.epmValue ?? 0 < $1.epmValue ??
                    0 }).last?.epmValue ?? 0)
            ])
            .padding(.trailing, .HPSpacing.xxxlarge)
            .padding(.bottom, .HPSpacing.large)
            .frame(maxWidth: .infinity, maxHeight: 300, alignment: .topTrailing)
            .scaledToFill()
            .overlay {
                HStack {
                    HStack(spacing: .HPSpacing.xxxxsmall) {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.HPComponent.stroke)
                            .background(Color.HPComponent.appropriateSpeed)
                            .frame(width: 12, height: 12)
                        Text("적정 속도")
                            .systemFont(.caption)
                            .foregroundStyle(Color.HPTextStyle.base)
                    }
                    HStack(spacing: .HPSpacing.xxxxsmall) {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.HPPrimary.base)
                            .background(Color.HPPrimary.base)
                            .frame(width: 12, height: 12)
                        Text("이번 연습")
                            .systemFont(.caption)
                            .foregroundStyle(Color.HPTextStyle.base)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.trailing, .HPSpacing.xxxlarge)
            }
        }
        .onAppear {
            sentences = sentences.sorted(by: { $0.index < $1.index })
        }
    }
        
}

extension SpeedAverageChart {
    @ViewBuilder
    var header: some View {
        let rate =  if averageEPM > 288 && averageEPM < 422.4 {"적절"} else {"부적절"}
        VStack(alignment: .leading, spacing: 8) {
            Text("평균 발화 속도")
                .systemFont(.subTitle)
                .foregroundStyle(Color.HPTextStyle.darker)
            HStack(spacing: 0) {
                Text("이번 연습의 평균 속도는 ")
                    .systemFont(.body)
                    .foregroundStyle(Color.HPTextStyle.dark)
                Text("\(String(format: "%.0f", averageEPM))EPM")
                    .systemFont(.body)
                    .foregroundStyle(Color.HPPrimary.base)
                Text(" 으로 ")
                    .systemFont(.body)
                    .foregroundStyle(Color.HPTextStyle.dark)
                Text("\(rate)했어요.")
                    .systemFont(.body)
                    .foregroundStyle(Color.HPPrimary.base)
            }
        }
        .padding(.top, .HPSpacing.xsmall)
        .padding(.bottom, .HPSpacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

// #Preview {
//    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//    return SpeedAverageChart(data: $practice)
// }
