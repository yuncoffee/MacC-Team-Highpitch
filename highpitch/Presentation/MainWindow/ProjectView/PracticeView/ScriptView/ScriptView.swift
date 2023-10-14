//
//  ScriptView.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct ScriptView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("내 발표 다시보기")
            ScrollView {
                Text("스크립트")
                    .frame(
                        maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                        maxHeight: .infinity
                    )
            }
            .padding(.bottom, 64)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .border(.blue)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}

#Preview {
    ScriptView()
}
