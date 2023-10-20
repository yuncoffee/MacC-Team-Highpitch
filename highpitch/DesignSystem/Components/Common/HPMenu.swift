//
//  HPMenu.swift
//  highpitch
//
//  Created by yuncoffee on 10/20/23.
//

import SwiftUI

struct HPMenu: View {
    var selected = ""
    
    @State
    var myPiced = "ㅋㅋ"
    
    @State
    var options = ["zz", "ㅋㅋ", "ㅒㅇㄹㄴㅇㄹ", "dflsjdf"]
    
    @State private var isPopoverVisible = false
    @State private var selectedOption = 0
    @State var showList: Bool = false
//
//    init() {
//        NSPopUpButton.wantsLayer = true
//    }
//    
    var body: some View {
        VStack {
            NSPopUpButtonView(selectedOption: $myPiced, options: options)
//            ZStack {
//                /// 선택된 뷰
//                HStack {
//                    Text("\(myPiced)")
//                    Label("chevron", systemImage: "chevron.right")
//                        .fontWeight(.heavy)
//                        .foregroundStyle(Color.HPTextStyle.darker)
//                        .labelStyle(.iconOnly)
//                        .frame(width: 16, height: 16)
//                        .offset(x: 30)
//                        .zIndex(1)
//                }
//                Menu {
//                    ForEach(options, id: \.self) { opendKeynote in
//                        Button {
//                            myPiced = opendKeynote
//                        } label: {
//                            Text("\(opendKeynote)")
//                                .onTapGesture {
//                                    myPiced = opendKeynote
//                                }
//                        }
//                    }
//                } label: {
//                    HStack(spacing: 0) {
//                        Text("selected: \(myPiced)")
//                            .systemFont(.caption2)
//                    }
//                    .padding(.vertical, 3)
//                    .padding(.leading, 7)
//                    .padding(.trailing, 3)
//                }
//                .menuIndicator(.hidden)
//                .menuStyle(MenubarExtraMenuStyle())
//            }
//            .frame(height: 22)
//    //        .background(Color.HPGray.systemWhite)
//            .clipShape(RoundedRectangle(cornerRadius: 5))
//            .shadow(color: .black.opacity(0.3), radius: 2.5)
//            Menu("Actions") {
//                Button("Duplicate", action:{})
//                Button("Rename", action: {})
//                Button("Delete…", action: {})
//                Menu("Copy") {
//                    Button("Copy", action: {})
//                    Button("Copy Formatted", action: {})
//                    Button("Copy Library Path", action: {})
//                }
//            }
//            .menuStyle(MenubarExtraMenuStyle())
        }
        .background(Color.white)
        .frame(maxHeight: 22)
    }
}

struct MenubarExtraMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
         Menu(configuration)
            .padding(.vertical, 24)
            .background(Color.yellow)
        
    }
}

#Preview {
    HPMenu()
        .padding(24)
}

struct NSPopUpButtonView: NSViewRepresentable {
    @Binding var selectedOption: String
    var options: [String]

    func makeNSView(context: Context) -> NSPopUpButton {
        let popUpButton = NSPopUpButton(frame: .zero, pullsDown: false)
        let cell = NSPopUpButtonCell()
        cell.arrowPosition = .noArrow
        popUpButton.isTransparent = true
        popUpButton.cell = cell
        popUpButton.isBordered = false
        popUpButton.bezelColor = .audiocontroller
        popUpButton.addItems(withTitles: options)
        popUpButton.target = context.coordinator
        popUpButton.action = #selector(Coordinator.popUpButtonAction(_:))
  
        for index in 0..<options.count {
            popUpButton.menu?.items[index].attributedTitle = NSAttributedString(
                string: options[index],
                attributes: [.font: NSFont.systemFont(ofSize: 13, weight: .medium)])
        }
    
        return popUpButton
    }

    func updateNSView(_ nsView: NSPopUpButton, context: Context) {
        let selectedMenuItem = nsView.selectedItem
        nsView.isTransparent = true
        let selectedFont = NSFont.systemFont(ofSize: 13)
        let attributes: [NSAttributedString.Key: Any] = [.font: selectedFont]
         selectedMenuItem?.attributedTitle = NSAttributedString(string: selectedMenuItem?.title ?? "", attributes: attributes)
        nsView.selectItem(withTitle: selectedOption)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: NSPopUpButtonView

        init(_ parent: NSPopUpButtonView) {
            self.parent = parent
        }

        @objc func popUpButtonAction(_ sender: NSPopUpButton) {
            if let selectedOption = sender.titleOfSelectedItem {
                parent.selectedOption = selectedOption
            }
        }
    }
}
