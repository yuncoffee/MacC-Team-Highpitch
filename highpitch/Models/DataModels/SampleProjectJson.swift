//
//  SampleProjectModel.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import Foundation

/// 번들의 샘플.json
struct SampleProjectJson: Codable {
    let utterances: [Utterance]
    
    struct Utterance: Codable {
        var startAt: Int
        var duration: Int
        var message: String
        
        // swiftlint: disable nesting
        enum CodingKeys: String, CodingKey {
            case startAt = "start_at"
            case duration = "duration"
            case message = "msg"
        }
        // swiftlint: enable nesting
    }
}
