//
//  ProjectFileManager.swift
//  HighPitchMacC
//
//  Created by yuncoffee on 10/9/23.
//

import Foundation
import SwiftData

final class ProjectFileManager: ObservableObject {
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
}
