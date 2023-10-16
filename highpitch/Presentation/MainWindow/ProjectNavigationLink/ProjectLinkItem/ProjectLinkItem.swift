//
//  ProjectLinkItem.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct ProjectLinkItem: View {
    
    var title: String = "Placeholder"
    var isSelected = false
    var completion: () -> Void = {
        print("Default Action")
    }
    
    var body: some View {
        Button {
            completion()
        } label: {
            let weight: FoundationTypoSystemFont.FontWeight = if isSelected { .bold } else { .medium }
            let color: Color = if isSelected { .HPTextStyle.darker } else { .HPTextStyle.base }
            let backgroundColor: Color = if isSelected { .HPPrimary.lightness } else { .clear }
            Text(title)
                .systemFont(.body, weight: weight)
                .foregroundStyle(color)
                .frame(maxWidth: .infinity, minHeight: 32, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .background(backgroundColor)
                .cornerRadius(7)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        
    }
}

#Preview {
    VStack(content: {
        ProjectLinkItem()
        ProjectLinkItem(isSelected: true)
    })
}
