//
//  FastSentReplay.swift
//  highpitch
//
//  Created by 이용준의 Macbook on 10/17/23.
//

import SwiftUI

struct FastSentReplay: View {
    @Binding
    var data: PracticeModel
    @State var disclosureToggle = false
    
    var body: some View {
        if !data.summary.fastSentenceIndex.isEmpty {
            Text("빠르게 말한 구간 듣기")
                .onTapGesture {
                    disclosureToggle.toggle()
                }
            if disclosureToggle {
                ForEach(data.sentences.sorted(by: { $0.epmValue! < $1.epmValue! })) { each in
                    if each.epmValue! > 422.4 {
                        Text("\(each.sentence)")
                            .onTapGesture { print(each.startAt) }
                    }
                }
            }
        }
    }
}

// #Preview {
//    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//    return FastSentReplay(data: $practice)
// }
