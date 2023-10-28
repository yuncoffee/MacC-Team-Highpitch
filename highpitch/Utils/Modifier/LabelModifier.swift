//
//  LabelModifier.swift
//  highpitch
//
//  Created by yuncoffee on 10/17/23.
//

import Foundation
import SwiftUI

struct TextWithIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.title
            configuration.icon
        }
    }
}

struct VerticalIconWithTextLabelStyle: LabelStyle {
    var iconSize: CGFloat?
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 2) {
            if let iconSize = iconSize {
                configuration.icon
                    .font(.system(size: iconSize))
                configuration.title
            } else {
                configuration.icon
                configuration.title
            }
        }
    }
}
