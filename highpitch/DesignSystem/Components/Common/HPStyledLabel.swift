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
            .systemFont(.caption2, weight: .semibold)
            .foregroundStyle(Color.HPPrimary.base)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.HPComponent.Tag.background)
            .clipShape(
                RoundedRectangle(cornerRadius: 4)
            )
    }
}

#Preview {
    HPStyledLabel()
}
