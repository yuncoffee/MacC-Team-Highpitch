//
//  HomeView.swift
//  Highpitch
//
//  Created by Yun Dongbeom on 2023/09/20.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeVM()
    @State var views = ["발표 연습하기", "연습 기록보기"]
    @State var isProjectOpen = false
    @State var sidebarStatus = 0
    @State private var isModalActive = false
    
    var body: some View {
        VStack(alignment: .leading) {
            projectLogoView()
            newProjectViewContainer()
            hasProjectListViewContainer()
        }
        .padding(.top, 68)
        .padding(.horizontal, 128)
        .frame(
            minWidth: 960,
            maxWidth: .infinity,
            minHeight: 640,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .navigationDestination(isPresented: $isProjectOpen) {
            ProjectView()
                .toolbar(.hidden, for: .automatic)
        }
        .sheet(isPresented: $isModalActive, content: {
            Text("HH")
        })
        .onAppear {
            vm.updateProjects()
        }
    }
}

extension HomeView {
    // MARK: - projectLogoView
    private func projectLogoView() -> some View {
        Image(.SystemImage.mainLogo.rawValue)
            .resizable()
            .scaledToFit()
            .frame(height: 35)
    }
    
    // MARK: - newProjectView
    private func newProjectViewContainer() -> some View {
        VStack(alignment: .leading) {
            // TextContainer
            VStack(alignment: .leading, spacing: 12) {
                Text("새 프로젝트")
                    .systemFont(.title)
                Text("새 프로젝트를 추가해서 제작해보세요")
                    .systemFont(.subHeadline)
                    .foregroundColor(.systemGray600)
            }
            VStack {
                Image(systemName: "folder.badge.plus")
                Button {
                    print("프로젝트 생성..!")
                } label: {
                    Text("프로젝트 생성하기")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(alignment: .topLeading)
        .border(.red)
    }
    
    // MARK: - hasProjectListiew
    private func hasProjectListViewContainer() -> some View {
        VStack(alignment: .leading) {
            Text("이전 프로젝트")
                .font(.largeTitle)
            VStack {
                GeometryReader { geometry in
                    let containerWidth = geometry.size.width
                    let itemWidth = (containerWidth - 56 * 3) / 4
                    
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(minimum: itemWidth), spacing: 56),
                                GridItem(.flexible(minimum: itemWidth), spacing: 56),
                                GridItem(.flexible(minimum: itemWidth), spacing: 56),
                                GridItem(.flexible(minimum: itemWidth), spacing: 56)
                            ], spacing: 40) {
                                ForEach(0...20, id: \.self) { index in
                                    VStack(alignment: .leading) {
                                        ZStack {
                                            Image(.SystemImage.mainLogo.rawValue)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100)
                                        }
                                        .frame(maxWidth: .infinity, minHeight: itemWidth / 16 * 9)
                                        .background(Color.black)
                                        Text("프로젝트 샘플 - \(index + 1) - \(itemWidth)")
                                            .font(.body)
                                            .lineLimit(1)
                                        Text("\(Date().description)")
                                            .font(.footnote)
                                            .lineLimit(1)
                                    }
                                    .frame(
                                        maxWidth: .infinity
                                    )
                                    .border(.red)
                                    .onTapGesture {
                                        sidebarStatus = 0
                                        isProjectOpen.toggle()
                                    }
                                }
                            }
                    }
                }
                
            }
            .frame(maxWidth: .infinity)
        }
        .frame(alignment: .topLeading)
        .border(.red)
    }
    
    private func projectCard() -> some View {
        VStack {
            if let project = vm.projects.first {
                AsyncImage(url: project.thumbnail) { phase in
                    phase.image?.resizable().scaledToFit()
                }
                .frame(width: 380, height: 180)
                Text(project.projectName)
                Text(project.createAt.description)
            }
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
