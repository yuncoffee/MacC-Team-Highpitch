//
//  PracticeModel.swift
//  highpitch
//
//  Created by yuncoffee on 10/12/23.
//

import Foundation

struct Practice: Codable {
    var id = UUID()
    var audioPath: URL
    var utterances: [Utterance]
}
