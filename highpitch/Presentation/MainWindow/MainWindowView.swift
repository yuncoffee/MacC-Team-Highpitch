//
//  MainWindowView.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

import SwiftUI
import SwiftData

struct MainWindowView: View {
    @Environment(MediaManager.self)
    private var mediaManager
    @Environment(KeynoteManager.self)
    private var keynoteManager
    
    // MARK: - SwiftUI View에서만 동작
    @Query(sort: \Sample.name)
    var samples: [Sample]
    
    @Environment(\.modelContext)
    var modelContext
    
    var body: some View {
        @Bindable var mediaManager = mediaManager
        @Bindable var keynoteManager = keynoteManager
        VStack {
            Text("isKeynoteOpen: \(keynoteManager.isKeynoteProcessOpen.description)")
            Text("MediaManager: \(mediaManager.keynoteIsOpen.description)")
//            Text("\(mediaManager.test)")
//            TextField("TestMyString", text: $mediaManager.myString)
//            Button {
//                let newItem = Sample(name: "Hello")
//                modelContext.insert(newItem)
//            } label: {
//                Text("add")
//            }
//            Button {
//                do {
//                    try modelContext.delete(model: Sample.self)
//                } catch {
//                    print("Error: Failed to delete")
//                }
//                
//            } label: {
//                Text("Delete")
//            }
//            ForEach(samples, id: \.self ) { sample in
//                Text(sample.name)
//            }
//            Text("\(samples.count)")
        }
        .onChange(of: keynoteManager.isKeynoteProcessOpen) { oldValue, newValue in
            mediaManager.keynoteIsOpen = !newValue
        }
    }
}

#Preview {
    MainWindowView()
}
