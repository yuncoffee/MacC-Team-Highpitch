//
//  WordModel.swift
//  highpitch
//
//  Created by 이용준의 Macbook on 10/19/23.
//

import Foundation
import SwiftData

@Model
class WordModel {
    var isFillerWord: Bool
    var sentenceIndex: Int
    var index: Int
    var word: String
    
    init(isFillerWord: Bool, sentenceIndex: Int, index: Int, word: String) {
        self.isFillerWord = isFillerWord
        self.sentenceIndex = sentenceIndex
        self.index = index
        self.word = word
    }
}
