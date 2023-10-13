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
                .background(isSelected ? Color.blue : Color.red)
        }
        .frame(maxWidth: .infinity, minHeight: 40)
    }
}

#Preview {
    ProjectLinkItem()
}
