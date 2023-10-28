//
//  HPButton.swift
//  highpitch
//
//  Created by yuncoffee on 10/28/23.
//

import SwiftUI

protocol ButtonComposable {}

extension HPLabel: ButtonComposable {}

struct HPButton<T: View>: StyleEssential, View where T: ButtonComposable {
    var type: LabelType = .blockFill(10)
    var size: ButtonSize = .large
    var color: Color = .HPPrimary.base
    var action: () -> Void
    var label: (
        _ type: LabelType,
        _ size: LabelSize,
        _ color: Color,
        _ expandable: Bool) -> T
    
    var body: some View {
        Button {
            action()
        } label: {
            label(type, size.labelSize, color, true)
                .contentShape(Rectangle())
                .frame(maxHeight: size.labelSize.height)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HPButton(
        type: .blockFill(10),
        size: .large,
        color: .HPSecondary.base) {
        print("Hello Button!")
    } label: { type, size, color, expandable in
        HPLabel(
            content: (label: "키노트 열기", icon: nil),
            type: type,
            size: size,
            color: color,
            alignStyle: .iconWithText,
            expandable: expandable,
            fontStyle: .system(.body),
            padding: (v: 8, h: 16)
        )
    }
    .fixedSize()
    .frame(width: 106)
    .frame(width: 200, height: 64)
    .border(.blue)
    .padding(24)
}
