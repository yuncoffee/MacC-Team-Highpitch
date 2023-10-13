//
//  ProjectNavigationLinkView.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct ProjectNavigationLink: View {
        
    var body: some View {
        VStack(spacing: 0) {
            Text("프로젝트 이름")
            ProjectLinkItem()
        }
    }
}

//ForEach(colors, id: \.self) { color in
//    Button(color.description) {
//        selection = color
//    }.background(selection == color ? Color.red : Color.cyan)
//}
//.border(.red, width: 2)


#Preview {
    ProjectNavigationLink()
}
