//
//  Project.swift
//  highpitch
//
//  Created by yuncoffee on 10/15/23.
//

import Foundation

struct Project {
    let id = UUID()
    var projectName: String
    var creatAt: String
    var keynotePath: URL?
    var practices: [Practice]
}
