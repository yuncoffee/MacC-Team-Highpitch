//
//  FeedbackChartView.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct FeedbackChartView: View {
    @Binding
    var practice: Practice
    
    var body: some View {
        VStack(spacing: 0) {
            Text("피드백")
            ScrollView {
                UsagePercentChart(data: $practice)
                UsageTopTierChart(data: $practice)
                FillerWordDetail(data: $practice)
                SpeedAverageChart(data: $practice)
                FastSentReplay(data: $practice)
            }
            .padding(.bottom, 64)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
    return FeedbackChartView(practice: $practice)
}
