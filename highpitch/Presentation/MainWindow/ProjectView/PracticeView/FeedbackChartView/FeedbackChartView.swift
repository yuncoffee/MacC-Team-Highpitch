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
                UsageTopTierChart()
                SpeedAverageChart()
            }
            .padding(.bottom, 64)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .border(.blue)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}

#Preview {
    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
    return FeedbackChartView(practice: $practice)
}
