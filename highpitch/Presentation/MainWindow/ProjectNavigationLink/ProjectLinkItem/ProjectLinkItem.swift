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
            Text(title)
                .font(Font.system(size: 16))
                .bold(isSelected)
                .frame(maxWidth: .infinity, minHeight: 32, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .background(isSelected ? Color("AC9FFF").opacity(0.3) : Color.clear)
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
