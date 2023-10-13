//
//  MainWindowView.swift
//  highpitch
//
//  Created by yuncoffee on 10/10/23.
//

#if os(macOS)
import SwiftUI
import SwiftData

struct MainWindowView: View {
    // MARK: - 데이터 컨트롤을 위한 매니저 객체
    @Environment(MediaManager.self)
    private var mediaManager
    @Environment(KeynoteManager.self)
    private var keynoteManager
    @Environment(ProjectManager.self)
    private var projectManager
    
    // MARK: - SwiftUI View에서만 동작
    @Query(sort: \Sample.name)
    var samples: [Sample]
    
    // MARK: - 데이터 저장을 위한 컨텍스트 객체
    @Environment(\.modelContext)
    var modelContext
    
    let colors: [Color] = [.purple, .pink, .orange]
    @State private var selection: Color? = .purple

    var body: some View {
        @Bindable var mediaManager = mediaManager
        @Bindable var keynoteManager = keynoteManager
        NavigationSplitView {
            LazyVGrid(columns: [GridItem()], alignment: .leading) {
                ProjectNavigationLink()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .border(.yellow, width: 2)
            .background(Color.blue)
            .navigationSplitViewColumnWidth(ideal: 120, max: 300)
        } detail: {
            if let color = selection {
                VStack(alignment: .leading, spacing: 0) {
                    // toolbar
                    HStack(content: {
                        /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                    })
                    .border(.blue, width: 2)
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(Color.brown)
                    VStack {
                        Text("Contents")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(color)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .border(.red, width: 2)
                .background(Color.yellow)
                .ignoresSafeArea()
            } else {
                Text("Pick a color")
            }
        }
        .toolbarBackground(.hidden)
        .frame(minWidth: 1000, minHeight: 600)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .onAppear(perform: {
            selection = colors[0]
        })
        .onChange(of: keynoteManager.isKeynoteProcessOpen) { _, newValue in
            mediaManager.keynoteIsOpen = !newValue
        }
    }
}

#Preview {
    MainWindowView()
        .environment(MediaManager())
        .environment(KeynoteManager())
}
#endif
