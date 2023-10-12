//
//  MenubarExtraView.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

import SwiftUI

struct MenubarExtraView: View {
    @Environment(AppleScriptManager.self)
    private var appleScriptManager
    @Environment(MediaManager.self)
    private var mediaManager
    @Environment(KeynoteManager.self)
    private var keynoteManager
    
    var body: some View {
        VStack {
            Button {
                getIsActiveKeynoteApp()
            } label: {
                Text("Apple Script Test")
            }
            Button {
                mediaManager.myString = "reset됨"
            } label: {
                Text("reset my String")
            }
            Button {
                exit(0)
            } label: {
                Text("quit")
            }
            Text("\(mediaManager.myString)")
        }
    }
}

extension MenubarExtraView {
    private func getIsActiveKeynoteApp() {
        Task {
            let result = await appleScriptManager.runScript(.isActiveKeynoteApp)
            if case .boolResult(let isKeynoteOpen) = result {
                // logic 2
                keynoteManager.isKeynoteProcessOpen = isKeynoteOpen
            }
        }
    }
}

#Preview {
    MenubarExtraView()
}
