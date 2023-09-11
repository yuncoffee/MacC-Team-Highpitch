//
//  TestView.swift
//  Highpitch
//
//  Created by Yun Dongbeom on 2023/09/11.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack {
            #if os(macOS)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, macOS")
            #else
            Image(systemName: "heart")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, iOS")
            #endif
        }
        .padding()
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
        TestView()
    }
}
