//
//  HPTooltip.swift
//  highpitch
//
//  Created by yuncoffee on 10/17/23.
//

import SwiftUI

struct HPTooltip: View {
    @State var isPopoverActive = false
    var tooltipContent: String
    var completion: (() -> Void)?
    
    var body: some View {
        Button {
            isPopoverActive.toggle()
            if let completion = completion {
                completion()
            }
        } label: {
            Label("도움말", systemImage: "questionmark.circle")
                .systemFont(.footnote)
                .labelStyle(.iconOnly)
                .foregroundStyle(Color.HPGray.system400)
                .frame(width: 20, height: 20)
        }
        .buttonStyle(.plain)
        .popover(isPresented: $isPopoverActive, content: {
            Text("ㅋㅋ")
                .padding(16)
        })
    }
}

#Preview {
    HPTooltip(tooltipContent: "도움말")
}
