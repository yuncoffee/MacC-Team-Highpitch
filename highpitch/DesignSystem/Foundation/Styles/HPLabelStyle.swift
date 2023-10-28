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
    case blockFill(CGFloat)
    case blockLine(CGFloat)
    case boxFill
    case boxLine
    case roundFill
    case roundLine
    case text
    case none
    
    var style: ComponentStyle? {
        switch self {
        case .blockFill:
            if case .blockFill(let HPCornerRadius) = self {
                return ComponentStyle(cornerStyle: .block(HPCornerRadius))
            }
        case .blockLine:
            if case .blockLine(let HPCornerRadius) = self {
                return ComponentStyle(cornerStyle: .block(HPCornerRadius), fillStyle: .line)
            }
        case .boxFill:
            return ComponentStyle(fillStyle: .fill)
        case .boxLine:
            return ComponentStyle(fillStyle: .line)
        case .roundFill:
            return ComponentStyle(cornerStyle: .round, fillStyle: .fill)
        case .roundLine:
            return ComponentStyle(cornerStyle: .round, fillStyle: .line)
        case .text:
            return ComponentStyle(fillStyle: .text)
        case .none:
            return nil
        }
        return nil
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
            36
        case .large:
            40
        case .xlarge:
            44
        }
    }
}

// swiftlint:disable function_body_length
struct HPLabelStyle: LabelStyle, StyleEssential, LabelStyleEssential {
    var type: LabelType = .blockFill(.HPCornerRadius.medium)
    var size: LabelSize = .small
    var color: Color = .clear
    
    var alignStyle: LabelAlignStyle = .textOnly
    var iconSize: CGFloat?
    
    var expandable: Bool = false
    var fontStyle: HPFont = .system(.caption)
    var width: CGFloat?
    var padding: (v: CGFloat, h: CGFloat)
    
    func makeBody(configuration: Configuration) -> some View {
        if type.style == nil {
            HStack(spacing: .HPSpacing.xxxxsmall) {
                configuration.icon
                configuration.title
            }
        } else {
            if let style = type.style {
                switch fontStyle {
                case .system(let foundationTypoSystemFont):
                    HPLabelContent(
                        configuration: configuration,
                        type: type,
                        size: size,
                        color: color,
                        alignStyle: alignStyle,
                        iconSize: iconSize
                    )
                    .systemFont(foundationTypoSystemFont)
                    .padding(.vertical, padding.v)
                    .padding(.horizontal, padding.h)
                    .frame(
                        minWidth: width,
                        maxWidth: .infinity,
                        minHeight: size.height,
                        maxHeight: expandable ? .infinity : nil)
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
                            cornerRadius: style.cornerStyle.cornerRadius)
                        .stroke(
                            style.fillStyle.isLook(.text)
                            ? .clear
                            : color, lineWidth: 2)
                        .cornerRadius(style.cornerStyle.cornerRadius)
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: style.cornerStyle.cornerRadius)
                    )
                case .styled(let HPStyledFont):
                    HPLabelContent(
                        configuration: configuration,
                        type: type,
                        size: size,
                        color: color,
                        alignStyle: alignStyle,
                        iconSize: iconSize
                    )
                    .styledFont(HPStyledFont)
                    .padding(.vertical, padding.v)
                    .padding(.horizontal, padding.h)
                    .frame(
                        minWidth: width,
                        maxWidth: .infinity,
                        minHeight: size.height,
                        maxHeight: expandable ? .infinity : nil)
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
                            cornerRadius: style.cornerStyle.cornerRadius)
                        .stroke(
                            style.fillStyle.isLook(.text)
                            ? .clear
                            : color, lineWidth: 2)
                        .cornerRadius(style.cornerStyle.cornerRadius)
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: style.cornerStyle.cornerRadius)
                    )
                }
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
