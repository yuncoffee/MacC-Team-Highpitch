//
//  SystemFont.swift
//  Highpitch
//
//  Created by Yun Dongbeom on 2023/09/21.
//

import Foundation
import SwiftUI

// swiftlint:disable identifier_name
extension View {
    func systemFont(
        _ style: FoundationTypoSystemFont,
        weight: FoundationTypoSystemFont.FontWeight? = nil) -> some View {
        modifier(HPSystemFontModifier(style: style, weight: weight))
    }
}

struct HPSystemFontModifier: ViewModifier {
    var style: FoundationTypoSystemFont
    var weight: FoundationTypoSystemFont.FontWeight?
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom(
                weight?.fontName ?? style.fontWeight.fontName,
                size: style.fontSize,
                relativeTo: style.relateTo)
            )
            .lineSpacing(style.lineHeight)
    }
}

enum FoundationTypoSystemFont {
    case largeTtile
    case title
    case subTitle
    case headline
    case subHeadline
    case body
    case footnote
    case caption
}

extension FoundationTypoSystemFont {
    enum FontWeight {
        case ultraLight
        case thin
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
        case black
    }
}

extension FoundationTypoSystemFont {
    var fontSize: CGFloat {
        switch self {
        case .largeTtile:
            return 32
        case .title:
            return 24
        case .subTitle:
            return 20
        case .headline:
            return 18
        case .subHeadline:
            return 16
        case .body:
            return 14
        case .footnote:
            return 12
        case .caption:
            return 10
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .largeTtile:
            return (48 - self.fontSize) / 2
        case .title:
            return (36 - self.fontSize) / 2
        case .subTitle:
            return (28 - self.fontSize) / 2
        case .headline:
            return (26 - self.fontSize) / 2
        case .subHeadline:
            return (24 - self.fontSize) / 2
        case .body:
            return (20 - self.fontSize) / 2
        case .footnote:
            return (18 - self.fontSize) / 2
        case .caption:
            return (12 - self.fontSize) / 2
        }
    }
    
    var fontWeight: FoundationTypoSystemFont.FontWeight {
        switch self {
        case .largeTtile:
            return .bold
        case .title:
            return .bold
        case .subTitle:
            return .regular
        case .headline:
            return .regular
        case .subHeadline:
            return .regular
        case .body:
            return .regular
        case .footnote:
            return .regular
        case .caption:
            return .regular
        }
    }
    
    var relateTo: Font.TextStyle {
        switch self {
        case .largeTtile:
            return .largeTitle
        case .title:
            return .title
        case .subTitle:
            return .title3
        case .headline:
            return .headline
        case .subHeadline:
            return .subheadline
        case .body:
            return .body
        case .footnote:
            return .footnote
        case .caption:
            return .caption2
        }
    }
}

extension FoundationTypoSystemFont.FontWeight {
    var fontName: String {
        switch self {
        case .ultraLight:
            return "Pretendard-Thin"
        case .thin:
            return "Pretendard-ExtraLight"
        case .light:
            return "Pretendard-Light"
        case .regular:
            return "Pretendard-Regular"
        case .medium:
            return "Pretendard-Medium"
        case .semibold:
            return "Pretendard-SemiBold"
        case .bold:
            return "Pretendard-Bold"
        case .heavy:
            return "Pretendard-ExtraBold"
        case .black:
            return "Pretendard-Black"
        }
    }
}
// swiftlint:enable identifier_name
