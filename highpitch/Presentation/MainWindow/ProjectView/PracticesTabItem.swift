//
//  PracticesTabItem.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct PracticesTabItem: View {
    @Binding 
    var mocks: [MockHuman]
    
    var body: some View {
        NavigationStack {
            List(mocks) { mock in
                VStack {
                    Text("연습카드")
                    NavigationLink(mock.name, value: mock)
                }
             }
            .navigationDestination(for: MockHuman.self) { mock in
                PracticeView(mock: mock)
            }
            .navigationTitle("mock")
        }
    }
}

#Preview {
    @State
    var mocks = [
        MockHuman(name: "111", ages: 10),
        MockHuman(name: "222", ages: 20),
        MockHuman(name: "333", ages: 30)
    ]
    return PracticesTabItem(mocks: $mocks)
}
