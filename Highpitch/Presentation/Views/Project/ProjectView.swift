//
//  ProjectView.swift
//  Highpitch
//
//  Created by Yun Dongbeom on 2023/09/20.
//

import SwiftUI

struct ProjectView: View {
    @StateObject var projectVM = ProjectVM()
    
    var body: some View {
        RecordView()
    }
}

struct ProjectView_Previews: PreviewProvider {
    @State static var sidebarStatus = 0
    
    static var previews: some View {
        ProjectView()
    }
}
