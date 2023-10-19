//
//  SentenceModel.swift
//  highpitch
//
//  Created by 이용준의 Macbook on 10/19/23.
//

import Foundation
import SwiftData

@Model
class SentenceModel {
    var index: Int
    var sentence: String
    var startAt: Int
    var endAt: Int
    var epmValue: Double?
    
    init(index: Int, sentence: String, startAt: Int, endAt: Int, epmValue: Double? = nil) {
        self.index = index
        self.epmValue = epmValue
        self.sentence = sentence
        self.startAt = startAt
        self.endAt = endAt
    }
}
