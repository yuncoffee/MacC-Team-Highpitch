//
//  UtterenceModel.swift
//  highpitch
//
//  Created by yuncoffee on 10/12/23.
//

import Foundation

struct Utterance: Codable {
    var id = UUID()
    var startAt: Int
    var duration: Int
    var message: String
}

extension Utterance: Hashable {}
