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
    var iconSize: CGFloat?
    
    var fontStyle: HPFont = .system(.caption)
    var width: CGFloat = 64
    var padding: (v: CGFloat, h: CGFloat) = (v: .HPSpacing.xxxxsmall, h: .HPSpacing.xxxxsmall)
    
    var body: some View {
        Label(content.label, systemImage: content.icon ?? "plus.square.fill")
            .labelStyle(HPLabelStyle(
                type: type,
                size: size,
                color: color,
                alignStyle: (content.icon != nil) ? alignStyle : .textOnly,
                iconSize: iconSize,
                width: width,
                padding: padding
            )
        )
    }
}

#Preview {
    VStack {
        HPLabel(
            type: .blockFill,
            size: .xsmall,
            color: .HPPrimary.base,
            alignStyle: .textWithIcon,
            iconSize: 18, fontStyle: .styled(.labeldButton),
            padding: (v: 0, h: 8)
        )
        .frame(width: 120)
        .padding(20)
        .frame(width: 600)
        .padding(40)
        .border(.red)
        HPLabel(
            content: (label: "Hello World!!!", icon: nil),
            size: .xsmall,
            fontStyle: .system(.caption2)
        )
    }
    .frame(maxWidth: 420)
}
