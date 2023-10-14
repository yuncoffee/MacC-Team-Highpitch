//
//  Color+Extension.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import Foundation
import SwiftUI

// swiftlint:disable identifier_name
extension Color {
    
    /// 컬러를 Hex값을 사용하기 위해 확장한 생성자
    ///
    /// 디자인 시스템 적용 전 빠르게 스타일 적용하기 위해 사용합니다.
    init(_ hex: String) {
        let scanner = Scanner(string: hex)
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
// swiftlint:enable identifier_name
