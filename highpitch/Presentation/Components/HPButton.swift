//
//  HPButton.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct HPButton: View {
    var body: some View {
        Button {
            print("Action")
        } label: {
            Text("Custom Button")
        }
    }
}

#Preview {
    HPButton()
}
