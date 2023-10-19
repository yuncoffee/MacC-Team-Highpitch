//
//  FillerWordModel.swift
//  highpitch
//
//  Created by 이용준의 Macbook on 10/19/23.
//

import Foundation
import SwiftData

@Model
class FillerWordModel {
    var fillerWord: String
    var count: Int
    
    init(fillerWord: String, count: Int = 0) {
        self.fillerWord = fillerWord
        self.count = count
    }
}
