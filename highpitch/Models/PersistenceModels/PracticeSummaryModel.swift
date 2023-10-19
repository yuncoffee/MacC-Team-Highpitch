//
//  PracticeSummaryModel.swift
//  highpitch
//
//  Created by 이용준의 Macbook on 10/19/23.
//

import Foundation
import SwiftData

@Model
class PracticeSummaryModel {
    var syllableSum: Int
    var durationSum: Int
    var wordCount: Int
    var fillerWordCount: Int
    var fastSpeechTime: Int
    var speechTime: Int
    var eachFillerWordCount: [FillerWordModel]
    var fastSentenceIndex: [Int]
    var fastSpeechRate: Double?
    var fillerWordPercentage: Double?
    var epmAverage: Double?
    var level: Double?
    
    init(
        syllableSum: Int = 0,
        durationSum: Int = 0,
        wordCount: Int = 0,
        fillerWordCount: Int = 0,
        fastSpeechTime: Int = 0,
        speechTime: Int = 0,
        eachFillerWordCount: [FillerWordModel] = [],
        fastSentenceIndex: [Int] = [],
        fastSpeechRate: Double? = nil,
        fillerWordPercentage: Double? = nil,
        epmAverage: Double? = nil,
        level: Double? = nil
    ) {
        self.syllableSum = syllableSum
        self.durationSum = durationSum
        self.wordCount = wordCount
        self.fillerWordCount = fillerWordCount
        self.fastSpeechTime = fastSpeechTime
        self.speechTime = speechTime
        self.eachFillerWordCount = eachFillerWordCount
        self.fastSentenceIndex = fastSentenceIndex
        self.fastSpeechRate = fastSpeechRate
        self.fillerWordPercentage = fillerWordPercentage
        self.epmAverage = epmAverage
        self.level = level
    }
}
