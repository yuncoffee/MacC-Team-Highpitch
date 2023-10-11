//
//  MenubarExtraView.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

import SwiftUI

struct MenubarExtraView: View {
    @Environment(MediaManager.self)
    private var mediaManager
    
    var body: some View {
        VStack {
            Button {
                mediaManager.test -= 1
            } label: {
                Text("--")
            }
            Button {
                mediaManager.test += 1
            } label: {
                Text("++")
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

#Preview {
    MenubarExtraView()
}
