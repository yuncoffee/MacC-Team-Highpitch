//
//  PracticeManager.swift
//  highpitch
//
//  Created by yuncoffee on 10/19/23.
//

import Foundation

@Observable
final class PracticeManager {
    
}

extension PracticeManager {
    
    // 해당 단어가 습관어인지 확인합니다.
    static func isFillerWord(practice: PracticeModel, word: String) -> Bool {
        for (index, fillerWord) in practice.summary.eachFillerWordCount.enumerated() where
        word.last! == "." ? fillerWord.fillerWord + "." == word : fillerWord.fillerWord == word {
            // fillerWordCount, eachFillerWordCount를 업데이트합니다.
            practice.summary.fillerWordCount += 1
            practice.summary.eachFillerWordCount[index].count += 1
            return true
        }
        return false
    }
    
    // eachFillerWordCount를 초기화합니다.
    static func initializer(practice: PracticeModel) {
        for fillerWord in FillerWordList().defaultList {
            practice.summary.eachFillerWordCount.append(FillerWordModel(fillerWord: fillerWord, count: 0))
        }
    }
    
    // summary에 들어가는 data를 업데이트합니다.
    static func updateSummary(practice: PracticeModel) {
        practice.summary.fastSpeechRate =
        Double(practice.summary.fastSpeechTime * 100) / Double(practice.summary.durationSum)
        practice.summary.fillerWordPercentage =
        Double(practice.summary.fillerWordCount * 100) / Double(practice.summary.wordCount)
        practice.summary.epmAverage =
        Double(practice.summary.syllableSum * 60000) / Double(practice.summary.durationSum)
        practice.summary.level = 0
        practice.summary.level += 5 - min(ceil(practice.summary.fillerWordPercentage / 0.03), 4)
        practice.summary.level += (abs(practice.summary.epmAverage - 356.7) < 20.7 ?  5 : 4 - min(ceil((abs(practice.summary.epmAverage - 356.7) - 20.7) / 25.0), 3))
        practice.summary.level /= 2.0
    }
    
    static func getPracticeDetail(practice: PracticeModel) {
        print("시작!!!!!!")
        
        initializer(practice: practice)
        // sentenceIndex와 wordIndex, sentenceSyllable을 관리합니다.
        var sentenceIndex = 0; var wordIndex = 0
        var sentenceSyllable: [Int] = [0]
        var sentenceDuration: [Int] = [0]
        var tempWords: [WordModel] = []
        var tempSentences: [SentenceModel] = []
        
        for (index, utterance) in practice.utterances.sorted().enumerated() {
            let messageLenght = utterance.message.components(separatedBy: " ").count
            for (index, word) in utterance.message.components(separatedBy: " ").enumerated() {
                // word와 관련한 값을 업데이트합니다.
                practice.summary.wordCount += 1
                practice.summary.syllableSum += word.count
                
                if sentenceIndex == sentenceSyllable.count - 1 { sentenceSyllable.append(0) }
                sentenceSyllable[sentenceIndex] += word.count
                if word.last! == "." {
                    practice.summary.syllableSum -= 1
                    sentenceSyllable[sentenceIndex] -= 1
                }
                
                // words, sentences의 sentence를 업데이트합니다.
                tempWords.append(WordModel(
                    isFillerWord: isFillerWord(practice: practice, word: word),
                    sentenceIndex: sentenceIndex,
                    index: wordIndex,
                    word: word + " "))
                
                if sentenceIndex == tempSentences.count {
                    tempSentences.append(SentenceModel(
                        index: sentenceIndex,
                        sentence: word,
                        startAt: utterance.startAt
                    ))
                } else {
                    tempSentences[sentenceIndex].sentence += (" " + word)
                }
                
                // 다음 단어로 넘깁니다.
                wordIndex += 1
            }
            
            // duration 및 endAt을 업데이트합니다.
            tempSentences[sentenceIndex].endAt = utterance.startAt + utterance.duration
            if sentenceIndex == sentenceDuration.count - 1 { sentenceDuration.append(0) }
            sentenceDuration[sentenceIndex] += utterance.duration
            practice.summary.durationSum += utterance.duration
            
            // 음절의 길이가 15가 넘거나, 마지막 문장이라면 문장을 끝냅니다.
            if sentenceSyllable[sentenceIndex] > 15 || index == practice.utterances.count - 1 {
                
                // EPM을 업데이트합니다.
                tempSentences[sentenceIndex].epmValue =
                Double(sentenceSyllable[sentenceIndex] * 60000) / Double(sentenceDuration[sentenceIndex])
                
                // sentence와 관련한 값을 업데이트합니다.
                if tempSentences[sentenceIndex].epmValue >= 422.4 {
                    practice.summary.fastSpeechTime += sentenceDuration[sentenceIndex]
                    practice.summary.fastSentenceIndex.append(sentenceIndex)
                }
                _ = tempWords.last!.word.popLast()
                for tempWord in tempWords { practice.words.append(tempWord) }
                tempWords.removeAll()
                practice.sentences.append(tempSentences[sentenceIndex])
                
                // 다음 문장으로 넘깁니다.
                sentenceIndex += 1
            }
        }
        updateSummary(practice: practice)
        print("끝")
    }
}
