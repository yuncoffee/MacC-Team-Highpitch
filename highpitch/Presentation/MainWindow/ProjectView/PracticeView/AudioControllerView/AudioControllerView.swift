//
//  AudioControllerView.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct AudioControllerView: View {
    @State
    private var speed = 50.0
    @State
    private var isEditing = false
    
    var body: some View {
        VStack {
            Slider(
                value: $speed,
                in: 0...100,
                onEditingChanged: { editing in
                    isEditing = editing
                }
            )
            Text("\(speed)")
                .foregroundColor(isEditing ? .red : .blue)
            HStack {
                Button {
                 print("prev")
                } label: {
                    Text("prev")
                }
                Button {
                 print("play")
                } label: {
                    Text("play")
                }
                Button {
                 print("next")
                } label: {
                    Text("next")
                }
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 64)
        .border(.red, width: 2)
    }
}

#Preview {
    AudioControllerView()
}
