//
//  MenubarExtraView.swift
//  HighPitchMacC
//
//  Created by yuncoffee on 10/9/23.
//

import SwiftUI

struct MenubarExtraView: View {
    @Environment(AudioMediaManager.self) private var audioMediaManager

    @State var selected = "1"
    @State var options = ["1", "2", "3"]
    @State var isShow = false
    @Binding var isMenuPresented: Bool
    
    var body: some View {
        if isMenuPresented {
            VStack {
                Picker("Select an Option", selection: $selected) {
                    ForEach(options, id: \.self) { option in
                        Text("\(option)")
                    }
                }
                .labelsHidden()
                Text("\(selected)")
                Button {
                    Task {
                        let result = await AppleScriptsManager.shared.runAppleScript(scriptSource: .bringToFrontKeynote, param: selected)
                    }
                    audioMediaManager.startRecording(title: "gg")
                } label: {
                    Text("Start Record")
                }
                Button {
                    audioMediaManager.stopRecording()
                } label: {
                    Text("Stop Record")
                }
                Button {
                    audioMediaManager.playRecording()
                } label: {
                    Text("Play Record")
                }

                Button {
                    print("clicked")
                    Task {
                        let result = await AppleScriptsManager.shared.runAppleScript(scriptSource: .isActiveKeynoteApp) as! Bool
                        print(result)
                    }
                } label: {
                    Text("Button")
                }
                
                Button {
                    Task {
                        let result = await AppleScriptsManager.shared.runAppleScript(scriptSource: .bringToFrontKeynote, param: selected)
                    }
                } label: {
                    Text("Button")
                }
            }
            .onAppear(perform: {
                Task {
                    let result = await AppleScriptsManager.shared.runAppleScript(scriptSource: .isActiveKeynoteApp) as? Bool
                    guard let result else {return}
                    if result {
                        let data = await AppleScriptsManager.shared.runAppleScript(scriptSource: .getCurrentKeynoteProcessList) as? [String]
                        var currentKeynotes: [String] = []
                        data?.forEach({ item in
                            currentKeynotes.append(item)
//                            if let keynoteName = item.split(separator: ":").last {
//                                currentKeynotes.append(keynoteName.description)
//                            }
                        })
                        options = currentKeynotes
                        if !options.isEmpty {
                            selected = options[0]
                        }
                    }
                }
            })
            .onDisappear(perform: {
                print("BYE!")
            })
            .frame(maxWidth: 320, maxHeight: 160)
        }
    }
}

#Preview {
    @State var value: Bool = true
    return MenubarExtraView(isMenuPresented: $value)
}
