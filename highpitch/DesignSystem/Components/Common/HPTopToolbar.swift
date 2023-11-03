//
//  HPTopToolbar.swift
//  highpitch
//
//  Created by yuncoffee on 10/17/23.
//

import SwiftUI

struct HPTopToolbar<T: View>: View {
    var title: String
    var subTitle: String?
    var backButtonCompletion: (() -> Void)?
    var completion: (() -> Void)
    var popOverContent: (() -> T)?
    
    @State
    private var isPopoverActive = false
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                if let completion = backButtonCompletion {
                    HPButton(color: .HPSecondary.base) {
                        completion()
                    } label: { type, size, color, expandable in
                        HPLabel(
                            content: (label: "키노트 열기", icon: nil),
                            type: type,
                            size: size,
                            color: color,
                            expandable: expandable,
                            fontStyle: .system(.body)
                        )
                    }
                    .frame(width: 120)
                    .padding(.leading, .HPSpacing.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            VStack(spacing: 0) {
                Text("\(title)")
                    .systemFont(.body)
                    .foregroundStyle(Color.HPTextStyle.darkness)
                    .onTapGesture {
                        if !isPopoverActive {
                            isPopoverActive = true
                        }
                    }
                    .popover(isPresented: $isPopoverActive, arrowEdge: .bottom) {
                        if let popOverContent {
                            popOverContent()
                        }
                    }
                    
                if let subTitle {
                    Text("\(subTitle)")
                        .systemFont(.caption)
                        .foregroundStyle(Color.HPTextStyle.light)
                }
            }
            .frame(maxWidth: .infinity)
            HStack(spacing: 0) {
                HPButton(color: .HPSecondary.base) {
                    print("키노트 열기")
                    completion()

                } label: { type, size, color, expandable in
                    HPLabel(
                        content: (label: "키노트 열기", icon: nil),
                        type: type,
                        size: size,
                        color: color,
                        expandable: expandable, 
                        fontStyle: .system(.body)
                    )
                }
                .frame(width: 120)
                .padding(.trailing, .HPSpacing.medium)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, minHeight: 64)
        .background(Color.HPGray.systemWhite)
        .border(.HPComponent.stroke, width: 1, edges: [.bottom])
    }
}

extension HPTopToolbar where T == EmptyView {
    init(
        title: String,
        subTitle: String?,
        backButtonCompletion: (() -> Void)?,
        completion: @escaping (() -> Void)
    ) {
        self.init(
            title: title,
            subTitle: subTitle,
            backButtonCompletion: backButtonCompletion,
            completion: completion,
            popOverContent: { EmptyView() }
        )
    }
    init(
        title: String,
        subTitle: String?,
        completion: @escaping (() -> Void)
    ) {
        self.init(
            title: title,
            subTitle: subTitle,
            backButtonCompletion: nil,
            completion: completion,
            popOverContent: { EmptyView() }
        )
    }
    init(
        title: String,
        completion: @escaping (() -> Void)
    ) {
        self.init(
            title: title,
            subTitle: nil,
            backButtonCompletion: nil,
            completion: completion,
            popOverContent: { EmptyView() }
        )
    }
}

#Preview {
    HPTopToolbar(title: "프로젝트 이름") {
        print("Hello")
    }
}
