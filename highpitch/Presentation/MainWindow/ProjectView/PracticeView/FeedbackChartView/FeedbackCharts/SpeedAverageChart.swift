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
    var practice: PracticeModel
    
    var body: some View {
        VStack {
            header
            Chart {
                // MARK: 적정 구간 인디케이터
                RectangleMark(
                    xStart: .value("", 0.5),
                    xEnd: .value("", Double(sentences.count) + 0.5),
                    yStart: .value("", 288),
                    yEnd: .value("", 422.4)
                )
                .foregroundStyle(Color.HPComponent.appropriateSpeed.opacity(0.5))
                if (sentences.count == 1) {
                    PointMark(
                        x: .value("문장 번호", 1),
                        y: .value("EPM", sentences.first?.epmValue ?? 0)
                    )
                    .foregroundStyle(Color.HPPrimary.base)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
                ForEach(sentences) { sentence in
                    LineMark(
                        x: .value("문장 번호", sentence.index + 1),
                        y: .value("EPM", sentence.epmValue ?? 0)
                    )
                    .foregroundStyle(Color.HPPrimary.base)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
            }
            .chartXAxisLabel(alignment: .trailing) {
                Text("(총 문장 수)")
                    .systemFont(.caption)
                    .foregroundStyle(Color.HPTextStyle.base)
            }
            .chartYAxisLabel(alignment: .topLeading) {
                Text("(EPM)")
                    .systemFont(.caption)
                    .foregroundStyle(Color.HPTextStyle.base)
            }
            .chartPlotStyle { plotArea in
                plotArea
                    .border(Color("EAEAEA"), width: 1)
                
            }
            .chartXAxis {
                AxisMarks(values: Array(stride(
                    from: 1,
                    to: sentences.count + 1,
                    by: 1
                ))) { value in
                    AxisValueLabel(centered: false) {
                        if (value.index == 0 || value.index == sentences.count - 1) {
                            Text("\(value.index + 1)")
                                .frame(height: 21)
                                .systemFont(.caption)
                                .offset(x: -7)
                                .foregroundStyle(Color.HPTextStyle.base)
                        } else {
//                            Text(".")
//                                .frame(height: 21)
//                                .systemFont(.caption)
//                                .offset(x: -7)
//                                .foregroundStyle(Color.HPTextStyle.base)
                        }
                    }
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
                                .padding(.trailing, 8)
                        }
                    }
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.HPGray.system200)
                }
            }
            .chartXScale(domain: [0.5, Double(sentences.count) + 0.5])
            .chartYScale(domain: [
                min(288.0, epmRange()[0]) - 10.0,
                max(422.4, epmRange()[1]) + 10.0
            ])
            .chartLegend(.hidden)
            .padding(.trailing, .HPSpacing.xxxlarge)
            .padding(.bottom, .HPSpacing.large)
            .frame(maxWidth: 800, maxHeight: 300, alignment: .topTrailing)
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
    
    func epmRange() -> [Double] {
        let sortedSentences = sentences.sorted(by: { $0.epmValue < $1.epmValue })
        return [
            sortedSentences.first!.epmValue,
            sortedSentences.last!.epmValue
        ]
    }
    
    @ViewBuilder
    var header: some View {
        let rate =  if practice.summary.epmAverage > 288 &&
        practice.summary.epmAverage < 422.4 {"적절"} else {"부적절"}
        VStack(alignment: .leading, spacing: 8) {
            Text("평균 말 빠르기")
                .systemFont(.subTitle)
                .foregroundStyle(Color.HPTextStyle.darker)
            HStack(spacing: 0) {
                Text("이번 연습의 평균 속도는 ")
                    .systemFont(.body)
                    .foregroundStyle(Color.HPTextStyle.dark)
                Text("\(String(format: "%.0f", practice.summary.epmAverage))EPM")
                    .systemFont(.body)
                    .foregroundStyle(Color.HPPrimary.dark)
                Text(" 으로 ")
                    .systemFont(.body)
                    .foregroundStyle(Color.HPTextStyle.dark)
                Text("\(rate)했어요.")
                    .systemFont(.body)
                    .foregroundStyle(Color.HPPrimary.dark)
            }
        }
        .padding(.top, .HPSpacing.xsmall)
        .padding(.bottom, .HPSpacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}
