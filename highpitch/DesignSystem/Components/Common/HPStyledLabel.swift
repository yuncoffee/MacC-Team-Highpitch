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
            .padding(4)
            .background(Color.HPComponent.mainWindowSidebarBackground)
            .clipShape(
                RoundedRectangle(cornerRadius: 4)
            )
    }
}

#Preview {
    HPStyledLabel()
}
