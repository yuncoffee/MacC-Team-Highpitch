//
//  OpendKeynote.swift
//  highpitch
//
//  Created by yuncoffee on 10/15/23.
//

import Foundation

@Observable
final class OpendKeynote: Identifiable, Equatable, Hashable {
    
    var id = UUID()
    var path = ""
    var creation = ""
    
    init(id: UUID = UUID(), path: String = "", creation: String = "") {
        self.id = id
        self.path = path
        self.creation = creation
    }
    
    static func == (lhs: OpendKeynote, rhs: OpendKeynote) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
          hasher.combine(id)
      }
}

extension OpendKeynote {
    func getFileName() -> String {
        var result = ""
        let paths = self.path.components(separatedBy: "/")
        if let lastItem = paths.last {
            if lastItem.isEmpty {
                result = paths[paths.endIndex - 2]
            } else {
                result = lastItem
            }
        }
        return result
    }
}
