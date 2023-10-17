//
//  SettingsView.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

/**
 사용자화 기능 필요
 */

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(MediaManager.self)
    private var mediaStore
    
    @Query(sort: \Sample.name)
    var samples: [Sample]
    
    var body: some View {
        VStack {
            Text("\(samples.isEmpty ? "none" : samples[0].name)")
            Text("Sample")
                .systemFont(.largeTitle)
            Text("SwiftUI ")
                .foregroundColor(.red)
            + Text("is ")
                .foregroundColor(.orange)
                .fontWeight(.black)
            + Text("awesome")
                .foregroundColor(.blue)
                .foregroundStyle(Color.HPPrimary.base)
            
        }
        .frame(minWidth: 200, minHeight: 200)
    }
}

#Preview {
    SettingsView()
        .environment(MediaManager())
}
