//
//  SettingsView.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(MediaManager.self)
    private var mediaStore
    
    @Query(sort: \Sample.name)
    var samples: [Sample]
    
    var body: some View {
        VStack {
            Text("\(mediaStore.myString)")
            Text("\(samples.isEmpty ? "none" : samples[0].name)")
        }
        .frame(minWidth: 200, minHeight: 200)
    }
}

#Preview {
    SettingsView()
}
