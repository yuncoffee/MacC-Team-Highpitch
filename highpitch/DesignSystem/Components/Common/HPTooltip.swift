//
//  HPTooltip.swift
//  highpitch
//
//  Created by yuncoffee on 10/17/23.
//

import SwiftUI

struct HPTooltip<T: View>: View {
    @State
    private var isPopoverActive = false
    var tooltipContent: String
    var arrowEdge: Edge = .top
    var content: (() -> T)?
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
        .popover(isPresented: $isPopoverActive, arrowEdge: arrowEdge, content: {
            if let content {
                content()
            } else {
                Text(tooltipContent)
                    .padding(.HPSpacing.xsmall)
            }
        })
    }
}

extension HPTooltip where T == EmptyView {
    init(tooltipContent: String, completion: (() -> Void)?) {
        self.init(
            tooltipContent: tooltipContent,
            arrowEdge: .top,
            content: {EmptyView()},
            completion: completion
        )
    }
    
    init(tooltipContent: String) {
        self.init(tooltipContent: tooltipContent, arrowEdge: .top, content: nil, completion: nil)
    }
}

#Preview {
    HPTooltip(tooltipContent: "도움말", completion: nil)
}
