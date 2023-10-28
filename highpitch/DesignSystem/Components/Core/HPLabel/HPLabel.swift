//
//  HPLabel.swift
//  highpitch
//
//  Created by yuncoffee on 10/28/23.
//

import SwiftUI

struct HPLabel: View, StyleEssential, LabelStyleEssential {
    var content: (label: String, icon: String?) = (label: "Label", icon: "plus.square.fill")
    var type: LabelType = .blockFill
    var size: LabelSize = .small
    var color: Color = .HPGray.system400
    var alignStyle: LabelAlignStyle = .iconWithText
    var fontStyle: HPFont = .system(.caption)
    var iconSize: CGFloat?
    var maxWidth: CGFloat = .infinity
    var padding: (v: CGFloat, h: CGFloat) = (v: .HPSpacing.xxxxsmall, h: .HPSpacing.xxxxsmall)
    
    var body: some View {
        switch fontStyle {
        case .system(let foundationTypoSystemFont):
            Label(content.label, systemImage: content.icon ?? "plus.square.fill")
                .labelStyle(HPLabelStyle(
                    type: type,
                    size: size,
                    color: color,
                    alignStyle: (content.icon != nil) ? alignStyle : .textOnly,
                    iconSize: iconSize,
                    maxWidth: maxWidth,
                    padding: padding
                    
                )
            )
            .systemFont(foundationTypoSystemFont)
            .fixedSize()
        case .styled(let hPStyledFont):
            Label(content.label, systemImage: content.icon ?? "plus.square.fill")
                .labelStyle(HPLabelStyle(
                    type: type,
                    size: size,
                    color: color,
                    alignStyle: (content.icon != nil) ? alignStyle : .textOnly,
                    iconSize: iconSize,
                    maxWidth: maxWidth,
                    padding: padding
                )
            )
            .styledFont(hPStyledFont)
            .fixedSize()
        }
    }
}

#Preview {
    VStack {
        HPLabel(
            type: .text,
            size: .xsmall,
            color: .HPPrimary.base,
            alignStyle: .textWithIcon,
            fontStyle: .styled(.labeldButton),
            iconSize: 18,
            padding: (v: 4, h: 8)
        )
        .border(.red)
        .frame(width: 600)
        .border(.red)
        .padding(40)
        .border(.red)
        HPLabel(
            content: (label: "Hello World!!!", icon: nil),
            size: .xsmall,
            fontStyle: .system(.caption2)
        )
    }
}
