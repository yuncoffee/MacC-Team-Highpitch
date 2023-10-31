//
//  HPListCell.swift
//  highpitch
//
//  Created by yuncoffee on 10/30/23.
//

import SwiftUI

protocol ListComposable {}

extension HPButton: ListComposable {}
extension EmptyView: ListComposable {}

struct HPListCell<S: View, N: View, B: View>: View where B: ListComposable {
    var title: String
    var subTitle: () -> S?
    var notification: () -> N?
    var button: () -> B?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    notification()
                        .frame(width: 8)
                    Text("\(title)")
                        .systemFont(.caption, weight: .semibold)
                        .foregroundStyle(Color.HPTextStyle.darker)
                }
                HStack(spacing: 0) {
                    subTitle()
                }
                .systemFont(.caption2)
                .foregroundStyle(Color.HPTextStyle.base)
                .frame(maxWidth: 200, alignment: .leading)
                .offset(x: notification() != nil ? 16 : 0)
            }
            Spacer()
            VStack {
                button()
                    .fixedSize()
                    .frame(height: ButtonSize.small.labelSize.height)
            }
        }
        .padding(.vertical, .HPSpacing.xxsmall)
        .padding(.trailing, .HPSpacing.xxxsmall)
        .border(.HPComponent.stroke, width: 1, edges: [.bottom])
    }
}

extension HPListCell where S == EmptyView, N == EmptyView, B == EmptyView {
    init(title: String, subTitle: Text?) {
        self.init(
            title: title,
            subTitle: { EmptyView() },
            notification: { EmptyView() },
            button: { EmptyView() }
        )
    }
    
    init(title: String) {
        self.init(
            title: title,
            subTitle: { EmptyView() },
            notification: { EmptyView() },
            button: { EmptyView() }
        )
    }
}

#Preview {
    let subText = Text("ㅋㅋㅋ")
    
    return VStack {
        HPListCell(
            title: "Hello",
            subTitle: {
                Text("ㅋㅋㅋ")
            },
            notification: {
                Circle()
                    .foregroundStyle(Color.blue)
            }, button: {
                HPButton(type: .text, size: .small, color: .HPTextStyle.base) {
                    print("Hello")
                } label: { type, size, color, expandable in
                    HPLabel(
                        content: ("확인하기", "chevron.right"),
                        type: type,
                        size: size,
                        color: color,
                        alignStyle: .textWithIcon,
                        expandable: expandable,
                        fontStyle: .system(.caption)
                    )
                }
            }
        )
        HPListCell(title: "Hello")
    }
    .padding(24)
}
