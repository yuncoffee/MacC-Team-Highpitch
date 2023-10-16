//
//  Typography.swift
//  highpitch
//
//  Created by yuncoffee on 10/16/23.
//

import Foundation
import SwiftUI

extension View {
    func systemFont(
        _ style: FoundationTypoSystemFont,
        weight: FoundationTypoSystemFont.FontWeight? = nil
    ) -> some View {
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
    case largeTitle
    case title
    case subTitle
//    case headline
//    case subHeadline
    case body
    case footnote
    case caption
    
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
        case .largeTitle:
            return 22
        case .title:
            return 20
        case .subTitle:
            return 18
//        case .headline:
//            return 18
//        case .subHeadline:
//            return 16
        case .body:
            return 16
        case .footnote:
            return 14
        case .caption:
            return 12
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .largeTitle:
            return ((self.fontSize + self.fontSize/2) - self.fontSize) / 2
        case .title:
            return ((self.fontSize + self.fontSize/2) - self.fontSize) / 2
        case .subTitle:
            return ((self.fontSize + self.fontSize/2) - self.fontSize) / 2
//        case .headline:
//            return (26 - self.fontSize) / 2
//        case .subHeadline:
//            return (24 - self.fontSize) / 2
        case .body:
            return ((self.fontSize + self.fontSize/2) - self.fontSize) / 2
        case .footnote:
            return ((self.fontSize + self.fontSize/2) - self.fontSize) / 2
        case .caption:
            return ((self.fontSize + self.fontSize/2) - self.fontSize) / 2
        }
    }
    
    var fontWeight: FoundationTypoSystemFont.FontWeight {
        switch self {
        case .largeTitle:
            return .bold
        case .title:
            return .bold
        case .subTitle:
            return .bold
//        case .headline:
//            return .regular
//        case .subHeadline:
//            return .regular
        case .body:
            return .medium
        case .footnote:
            return .medium
        case .caption:
            return .medium
        }
    }
    
    var relateTo: Font.TextStyle {
        switch self {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title
        case .subTitle:
            return .title3
//        case .headline:
//            return .headline
//        case .subHeadline:
//            return .subheadline
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
