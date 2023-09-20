//
//  HomeView.swift
//  Highpitch
//
//  Created by Yun Dongbeom on 2023/09/20.
//

import SwiftUI

struct HomeView: View {
    @State var views = ["발표 연습하기", "연습 기록보기"]
    @State var isProjectOpen = false
    
    var body: some View {
        HStack {
            List(views, id: \.self) { view in
                Text(view)
            }
            .frame(width: 172)
            VStack {
                // logo
                Image(systemName: "plus")
                // new project
                VStack {
                    Text("새 프로젝트")
                }
                // prev project
                VStack {
                    Text("이전 프로젝트")
                    VStack {
                        Text("프로젝트 샘플")
                            .onTapGesture {
                                isProjectOpen.toggle()
                            }
                    }
                }
            }
        }
        .navigationDestination(isPresented: $isProjectOpen) {
            ProjectView()
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}
