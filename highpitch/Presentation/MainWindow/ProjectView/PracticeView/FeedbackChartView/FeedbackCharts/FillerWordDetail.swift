//
//  FillerWordDetail.swift
//  highpitch
//
//  Created by 이용준의 Macbook on 10/17/23.
//

import SwiftUI

struct FillerWordDetail: View {
    @Binding
    var data: PracticeModel
    let fillerWordList = FillerWordList()
    @State var disclosureToggle = false
    
    var body: some View {
        var summary = data.summary
        
        VStack {
            if (summary.fillerWordCount > 0) {
                Text("언급된 습관어 상세보기")
                    .onTapGesture {
                        disclosureToggle.toggle()
                    }
                if (disclosureToggle) {
                    ForEach(summary.eachFillerWordCount.sorted(by: { $0.count > $1.count})) { each in
                        if each.count > 0 {
                            HStack {
                                Text("\(each.fillerWord)")
                                Text("\(each.count)회")
                            }
                        }
                    }
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 500,
            maxHeight: .infinity
        )
    }
}

// #Preview {
//    @State var practice = Practice(audioPath: Bundle.main.bundleURL, utterances: [])
//    return FillerWordDetail(data: $practice)
// }
