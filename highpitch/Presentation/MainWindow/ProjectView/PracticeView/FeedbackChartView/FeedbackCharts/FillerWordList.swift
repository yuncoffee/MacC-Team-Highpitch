//
//  FillerWordList.swift
//  highpitch
//
//  Created by 이용준의 Macbook on 10/14/23.
//

import Foundation

struct FillerWordList {
    private static let fillerWordStore = UserDefaults.standard
    static var userFillerWordList: [String] {
        get {
            if let fillerWords = loadFromUserDefaults() {
                return fillerWords
            } else {
                saveToUserDefaults(defaultList)
                return defaultList
            }
        }
        set {
            saveToUserDefaults(newValue)
        }
    }
    static func resetFillerWordList() {
        userFillerWordList = defaultList
    }
    private static let defaultList = [
        "음",
        "어",
        "아",
        "흠",
        "그",
        "막",
        "뭐",
        "뭔가",
        "사실은",
        "그래서",
        "아니",
        "이제",
        "인제",
        "근데",
        "저기",
        "약간",
        "뭐지",
        "뭐였지",
        "뭐였더라",
        "봐봐",
        "그니깐",
        "그러니까"
    ]
    private static func saveToUserDefaults(_ data: [String]) {
        do {
            let fillerWords = data
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(fillerWords) {
                UserDefaults.standard.set(encoded, forKey: "fillerWords")
            }
        }
    }

    private static func loadFromUserDefaults() -> [String]? {
        if let fillerWords = UserDefaults.standard.data(forKey: "fillerWords") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([String].self, from: fillerWords) {
                return decoded
            }
        }
        return nil
    }
}
