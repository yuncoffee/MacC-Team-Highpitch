//
//  PracticeManager.swift
//  highpitch
//
//  Created by yuncoffee on 10/19/23.
//

import Foundation

@Observable
final class PracticeManager {
    var practices: [PracticeModel]?
    var current: PracticeModel?
}

extension PracticeManager {
    
    // 해당 단어가 습관어인지 확인합니다.
    func isFillerWord(word: String) -> Bool {
        for (index, fillerWord) in current!.summary.eachFillerWordCount.enumerated() where
        word.last! == "." ? fillerWord.fillerWord + "." == word : fillerWord.fillerWord == word {
            // fillerWordCount, eachFillerWordCount를 업데이트합니다.
            current!.summary.fillerWordCount += 1
            current!.summary.eachFillerWordCount[index].count += 1
            return true
        }
        return false
    }
    
    // eachFillerWordCount를 초기화합니다.
    func initializer() {
        for fillerWord in FillerWordList().defaultList {
            current!.summary.eachFillerWordCount.append(FillerWordModel(fillerWord: fillerWord, count: 0))
        }
    }
    
    // summary에 들어가는 data를 업데이트합니다.
    func updateSummary() {
        current!.summary.fastSpeechRate =
        Double(current!.summary.fastSpeechTime * 100) / Double(current!.summary.durationSum)
        current!.summary.fillerWordPercentage =
        Double(current!.summary.fillerWordCount * 100) / Double(current!.summary.wordCount)
        current!.summary.epmAverage =
        Double(current!.summary.syllableSum * 60000) / Double(current!.summary.durationSum)
        current!.summary.level = 0
        current!.summary.level! += 5 - min(ceil(current!.summary.fillerWordPercentage! / 0.03), 4)
        current!.summary.level! += (abs(current!.summary.epmAverage! - 356.7) < 20.7 ?  5 : 4 - min(ceil((abs(current!.summary.epmAverage! - 356.7) - 20.7) / 25.0), 3))
        current!.summary.level! /= 2.0
    }
    
    func getPracticeDetail() {
        if let current = current {
            
            initializer()
            
            // sentenceIndex와 wordIndex, sentenceSyllable을 관리합니다.
            var sentenceIndex = 0; var wordIndex = 0
            var sentenceSyllable: [Int] = [0]
            var sentenceDuration: [Int] = [0]
            var tempWords: [WordModel] = []
            var tempSentences: [SentenceModel] = []
            
            for (index, utterance) in current.utterances.sorted().enumerated() {
                let messageLenght = utterance.message.components(separatedBy: " ").count
                for (index, word) in utterance.message.components(separatedBy: " ").enumerated() {
                    // word와 관련한 값을 업데이트합니다.
                    current.summary.wordCount += 1
                    current.summary.syllableSum += word.count
                    
                    if sentenceIndex == sentenceSyllable.count - 1 { sentenceSyllable.append(0) }
                    sentenceSyllable[sentenceIndex] += word.count
                    if word.last! == "." {
                        current.summary.syllableSum -= 1
                        sentenceSyllable[sentenceIndex] -= 1
                    }
                    
                    // words, sentences의 sentence를 업데이트합니다.
                    tempWords.append(WordModel(
                        isFillerWord: isFillerWord(word: word),
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
                current.summary.durationSum += utterance.duration
                
                // 음절의 길이가 15가 넘거나, 마지막 문장이라면 문장을 끝냅니다.
                if sentenceSyllable[sentenceIndex] > 15 || index == current.utterances.count - 1 {
                    
                    // EPM을 업데이트합니다.
                    tempSentences[sentenceIndex].epmValue =
                    Double(sentenceSyllable[sentenceIndex] * 60000) / Double(sentenceDuration[sentenceIndex])
                    
                    // sentence와 관련한 값을 업데이트합니다.
                    if tempSentences[sentenceIndex].epmValue! >= 422.4 {
                        current.summary.fastSpeechTime += sentenceDuration[sentenceIndex]
                        current.summary.fastSentenceIndex.append(sentenceIndex)
                    }
                    _ = tempWords.last!.word.popLast()
                    for tempWord in tempWords { current.words.append(tempWord) }
                    tempWords.removeAll()
                    current.sentences.append(tempSentences[sentenceIndex])
                    
                    // 다음 문장으로 넘깁니다.
                    sentenceIndex += 1
                }
            }
            updateSummary()
        }
        
    }
}
