//
//  HPStyledLabel.swift
//  highpitch
//
//  Created by yuncoffee on 10/17/23.
//

import SwiftUI

struct HPStyledLabel: View {
    var content: String = "컨텐츠"
    
    var body: some View {
        Text("\(content)")
            .systemFont(.footnote, weight: .semibold)
            .foregroundStyle(Color.HPPrimary.base)
            .padding(4)
            .background(Color.HPPrimary.light.opacity(0.1))
            .clipShape(
                RoundedRectangle(cornerRadius: 4)
            )
    }
}

#Preview {
    HPStyledLabel()
}
