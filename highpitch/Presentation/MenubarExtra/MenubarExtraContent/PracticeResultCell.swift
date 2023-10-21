//
//  PracticeResultCell.swift
//  highpitch
//
//  Created by yuncoffee on 10/21/23.
//

import SwiftUI

struct PracticeResultCell: View {
    var practice: PracticeModel
    var completion: () -> Void
    
    var body: some View {
        HStack {
            Text(practice.practiceName)
            Spacer()
            Button {
                completion()
            } label: {
                Text("자세히 보기")
            }
        }
        .background(Color("000000").opacity(0.1))
        .cornerRadius(5)
    }
}

#Preview {
    @State var practice = PracticeModel(
        practiceName: "",
        creatAt: "",
        utterances: [],
        summary: PracticeSummaryModel()
    )
    
    return PracticeResultCell(practice: practice) {
        print("Hello")
    }
}
