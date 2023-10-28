//
//  HPLabelStyle.swift
//  highpitch
//
//  Created by yuncoffee on 10/28/23.
//

import Foundation
import SwiftUI

protocol LabelStyleEssential {
    var alignStyle: LabelAlignStyle { get }
    var iconSize: CGFloat? { get }
}

enum LabelAlignStyle {
    case iconWithText
    case textWithIcon
    case iconOnly
    case textOnly
    case iconWithTextVertical
}

enum LabelType: ComponentBaseType {
    case blockFill
    case blockLine
    case boxFill
    case boxLine
    case roundFill
    case roundLine
    case text
    case none
    
    var style: ComponentStyle? {
        switch self {
        case .blockFill:
            ComponentStyle(cornerStyle: .block)
        case .blockLine:
            ComponentStyle(cornerStyle: .block, fillStyle: .line)
        case .boxFill:
            ComponentStyle(fillStyle: .fill)
        case .boxLine:
            ComponentStyle(fillStyle: .line)
        case .roundFill:
            ComponentStyle(cornerStyle: .round, fillStyle: .fill)
        case .roundLine:
            ComponentStyle(cornerStyle: .round, fillStyle: .line)
        case .text:
            ComponentStyle(fillStyle: .text)
        case .none:
            nil
        }
    }
}

enum LabelSize: ComponentBaseSize {
    case xsmall
    case small
    case medium
    case large
    case xlarge
    
    var font: FoundationTypoSystemFont {
        switch self {
        case .xsmall:
            .caption2
        case .small:
            .caption
        case .medium:
            .footnote
        case .large:
            .body
        case .xlarge:
            .subTitle
        }
    }
    
    var height: CGFloat {
        switch self {
        case .xsmall:
            26
        case .small:
            28
        case .medium:
            34
        case .large:
            38
        case .xlarge:
            44
        }
    }
}

// swiftlint:disable function_body_length
struct HPLabelStyle: LabelStyle, StyleEssential, LabelStyleEssential {
    var type: LabelType = .blockFill
    var size: LabelSize = .small
    var color: Color = .clear
    var alignStyle: LabelAlignStyle = .textOnly
    var iconSize: CGFloat?
    var maxWidth: CGFloat
    var padding: (v: CGFloat, h: CGFloat)
    
    func makeBody(configuration: Configuration) -> some View {
        if type == .none {
            configuration.icon
            configuration.title
        } else {
            if let style = type.style {
                HPLabelContent(
                    configuration: configuration,
                    type: type,
                    size: size,
                    color: color,
                    alignStyle: alignStyle,
                    iconSize: iconSize
                )
                .padding(.vertical, padding.v)
                .padding(.horizontal, padding.h)
                .frame(maxWidth: maxWidth, minHeight: size.height)
                .background(
                    style.fillStyle.isLook(.fill)
                    ? color
                    : .clear
                )
                .foregroundColor(
                    style.fillStyle.isLook(.fill)
                    ? .HPGray.systemWhite
                    : color
                )
                .overlay {
                    RoundedRectangle(
                        cornerRadius: style.cornerStyle.isLook(.block)
                        ? .HPCornerRadius.medium
                        : style.cornerStyle.isLook(.round)
                        ? .HPCornerRadius.round
                        : 0)
                    .stroke(
                        style.fillStyle.isLook(.text)
                        ? .clear
                        : color, lineWidth: 2)
                    .cornerRadius(style.cornerStyle.isLook(.block)
                                  ? .HPCornerRadius.medium
                                  : style.cornerStyle.isLook(.round)
                                  ? .HPCornerRadius.round
                                  : 0)
                }
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: style.cornerStyle.isLook(.block)
                        ? .HPCornerRadius.medium
                        : style.cornerStyle.isLook(.round)
                        ? .HPCornerRadius.round
                        : 0
                    )
                )
            }
        }
    }
}
// swiftlint:enable function_body_length

struct HPLabelContent: View, StyleConfiguration, LabelStyleEssential {
    var configuration: LabelStyleConfiguration
    var type: LabelType
    var size: LabelSize
    var color: Color
    var alignStyle: LabelAlignStyle
    var iconSize: CGFloat?
    
    var body: some View {
        if alignStyle == .iconWithTextVertical {
            VStack(spacing: .HPSpacing.xxxxsmall) {
                if let iconSize {
                    configuration.icon
                        .font(.system(size: iconSize))
                    configuration.title
                } else {
                    configuration.icon
                    configuration.title
                }
            }
        } else if alignStyle == .iconWithText {
            HStack(spacing: .HPSpacing.xxxxsmall) {
                if let iconSize {
                    configuration.icon
                        .font(.system(size: iconSize))
                    configuration.title
                } else {
                    configuration.icon
                    configuration.title
                }
            }
        } else if alignStyle == .textWithIcon {
            HStack(spacing: .HPSpacing.xxxxsmall) {
                if let iconSize {
                    configuration.title
                    configuration.icon
                        .font(.system(size: iconSize))
                } else {
                    configuration.title
                    configuration.icon
                }
            }
        } else if alignStyle == .iconOnly {
            if let iconSize {
                configuration.icon
                    .font(.system(size: iconSize))
            } else {
                configuration.icon
            }
            
        } else {
            configuration.title
        }
    }
}
