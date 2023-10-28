//
//  HPButton.swift
//  highpitch
//
//  Created by yuncoffee on 10/28/23.
//

import SwiftUI

struct HPButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
          Label("Sample", systemImage: "house.fill")
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HPButton {
        print("Hello Button!")
    }
    .padding(24)
}
