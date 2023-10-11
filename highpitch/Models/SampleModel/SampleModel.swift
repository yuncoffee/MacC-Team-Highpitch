//
//  SampleModel.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

import Foundation
import SwiftData

@Model
final class Sample {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
