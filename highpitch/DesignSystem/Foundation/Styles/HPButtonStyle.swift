//
//  HPButtonStyle.swift
//  highpitch
//
//  Created by yuncoffee on 10/28/23.
//

import Foundation

enum ButtonSize: ComponentBaseSize {
    case small
    case medium
    case large
    
    var labelSize: LabelSize {
        switch self {
        case .small:
            LabelSize.small
        case .medium:
            LabelSize.medium
        case .large:
            LabelSize.large
        }
    }
}
