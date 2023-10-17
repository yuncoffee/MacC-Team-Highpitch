//
//  Spacing.swift
//  highpitch
//
//  Created by yuncoffee on 10/17/23.
//

import Foundation

// MARK: - CornerRadius
extension CGFloat {
    struct HPCornerRadius {
        private init() {}
    }
}

// MARK: - Padding
extension CGFloat {
    /// padding, spacing, gap과 같은 뷰 간 간격 조정에 쓰이는 네임스페이스
    struct HPSpacing {
        private init() {}
        /// rawValue: 4
        static let xxxxsmall: CGFloat = 4
        /// rawValue: 8
        static let xxxsmall: CGFloat = 8
        /// rawValue: 12
        static let xxsmall: CGFloat = 12
        /// rawValue: 16
        static let xsmall: CGFloat = 16
        /// rawValue: 24
        static let small: CGFloat = 24
        /// rawValue: 32
        static let medium: CGFloat = 32
        /// rawValue: 40
        static let large: CGFloat = 40
        /// rawValue: 48
        static let xlarge: CGFloat = 48
        /// rawValue: 56
        static let xxlarge: CGFloat = 56
        /// rawValue: 64
        static let xxxlarge: CGFloat = 64
        
    }
}
