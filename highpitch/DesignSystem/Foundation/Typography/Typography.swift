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
    
    func styledFont(
        _ style: HPStyledFont,
        weight: FoundationTypoSystemFont.FontWeight? = nil
    ) -> some View {
        modifier(HPStyledFontModifier(style: style, weight: weight))
    }
}

struct HPStyledFontModifier: ViewModifier {
    var style: HPStyledFont
    var weight: FoundationTypoSystemFont.FontWeight?
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom(
                weight?.fontName ?? style.fontWeight.fontName,
                size: style.fontSize,
                relativeTo: style.relateTo)
            )
            .lineSpacing(style.lineHeight)
            .padding(.vertical, (style.fontSize*2 - style.fontSize*1.48)/2)
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
            .padding(.vertical, (style.fontSize*2 - style.fontSize*1.48)/2)
    }
}

enum HPStyledFont {
    case largeTitleLv
}

extension HPStyledFont {
    var fontSize: CGFloat {
        switch self {
        case .largeTitleLv:
            28
        }
    }
    var lineHeight: CGFloat {
        switch self {
        case .largeTitleLv:
            ((self.fontSize*1.68) - self.fontSize) / 2
        }
    }
    var fontWeight: FoundationTypoSystemFont.FontWeight {
        switch self {
        case .largeTitleLv:
            .bold
        }
    }
    var relateTo: Font.TextStyle {
        switch self {
        case .largeTitleLv:
            .largeTitle
        }
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
    case caption2
    
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
            return 24
        case .title:
            return 22
        case .subTitle:
            return 20
//        case .headline:
//            return 18
//        case .subHeadline:
//            return 16
        case .body:
            return 18
        case .footnote:
            return 16
        case .caption:
            return 14
        case .caption2:
            return 12
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .largeTitle:
            return ((self.fontSize*1.68) - self.fontSize) / 2
        case .title:
            return ((self.fontSize*1.68) - self.fontSize) / 2
        case .subTitle:
            return ((self.fontSize*1.68) - self.fontSize) / 2
//        case .headline:
//            return (26 - self.fontSize) / 2
//        case .subHeadline:
//            return (24 - self.fontSize) / 2
        case .body:
            return ((self.fontSize*1.68) - self.fontSize) / 2
        case .footnote:
            return ((self.fontSize*1.68) - self.fontSize) / 2
        case .caption:
            return (self.fontSize*1.68 - self.fontSize)/2
        case .caption2:
            return ((self.fontSize*1.68) - self.fontSize) / 2
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
            return .regular
        case .caption:
            return .regular
        case .caption2:
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
            return .caption
        case .caption2:
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
