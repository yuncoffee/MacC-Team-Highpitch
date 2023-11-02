//
//  OverlayView.swift
//  highpitch
//
//  Created by yuncoffee on 11/2/23.
//

import SwiftUI

struct OverlayView: View {
    @State private var window: NSWindow?
    @Binding var isActive: Bool
    
    var body: some View {
        VStack {
//            Text("Loading...")
            Button {
                window?.close()
            } label: {
                Text("Hello")
            }
            if nil != window {
                MainView(store: OverlayStore(window: window!))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.HPTeritiery.base)
        .background(WindowAccessor(window: $window))
        .onChange(of: isActive) { _, newValue in
            if newValue {
                window?.close()
            }
        }
    }
}

#Preview {
    @State var isActive = false
    
    return OverlayView(isActive: $isActive)
}

class OverlayStore {
    var window: NSWindow
    
    init(window: NSWindow) {
        window.level = NSWindow.Level(rawValue: 1000)
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        self.window = window
        self.window.isOpaque = false
        self.window.backgroundColor = NSColor.clear
    }
}

struct MainView: View {
    let store: OverlayStore
    
    var body: some View {
        VStack {
            Text("MainView with Window: \(store.window)")
                .font(.title)
                .foregroundStyle(Color.HPGray.systemWhite)
        }
        .frame(width: 400, height: 200)
        .background(Color.HPTextStyle.base)
//        .background(.thickMaterial)
    }
}

struct WindowAccessor: NSViewRepresentable {
    @Binding var window: NSWindow?
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}
