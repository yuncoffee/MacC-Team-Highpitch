//
//  PresentationView.swift
//  Highpitch
//
//  Created by Yun Dongbeom on 2023/09/20.
//

import SwiftUI

struct PresentationView: View {
    var body: some View {
        VStack {
            // header
            HStack {
                Button("<") {
                    print("<")
                }
                Text("프로젝트 명")
                Button("연습 끝내기") {
                    print("<")
                }
            }
            // body
            VStack {
                // PDF
                Image("plus")
            }
            // footer
            HStack {
                Image("plus")
                Text("REC")
                Circle().frame(width: 20, height: 20)
                
                Text("프로젝트 명")
                Button(">") {
                    print(">")
                }
                Text("00:00")
                Text("7/10(페이지)")
            }
        }
    }
}

struct PresentationView_Previews: PreviewProvider {
    static var previews: some View {
        PresentationView()
    }
}
