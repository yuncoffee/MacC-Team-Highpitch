//
//  HPSegmentedControl.swift
//  highpitch
//
//  Created by yuncoffee on 10/17/23.
//

import SwiftUI

struct HPSegmentedControl: View {
    @Binding
    var selectedSegment: Int
    var options: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                Button {
                    withAnimation(.interactiveSpring()) {
                        selectedSegment = index
                    }
                } label: {
                    ZStack(alignment: .trailing) {
                        let backgroundColor: Color = if selectedSegment == index {
                            .HPGray.systemWhite
                        } else { .clear }
                        let forgroundColor: Color = if selectedSegment == index {
                            .HPPrimary.base
                        } else { .HPTextStyle.light }
                        let strokeColor: Color = if selectedSegment == index {
                            .HPGray.system200
                        } else if index == selectedSegment - 1 {
                            .HPGray.system200 } else { .HPComponent.stroke }
                        if index < options.count - 1 {
                            Rectangle()
                                .frame(width: 1, height: 17)
                                .foregroundColor(
                                    strokeColor
                                )
                        }
                        Text(options[index])
                            .systemFont(.footnote, weight: .semibold)
                            // TODO: - Padding
                            .padding(.vertical, 5)
                            .padding(.horizontal, .HPSpacing.xsmall)
                            .foregroundStyle(forgroundColor)
                            .frame(minHeight: 33)
                            .background(backgroundColor)
                            .cornerRadius(5)
                            .shadow(color: .HPComponent.shadowBlackColor, radius: 8)
                            .contentShape(Rectangle())
                    }
                    .frame(alignment: .trailing)
                }
                .buttonStyle(.plain)
                .foregroundColor(.white)
            }
        }
        .padding(.HPSpacing.xxxxsmall)
        .background(Color.HPGray.system200)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    @State var selectedSegment = 0
    return HPSegmentedControl(
        selectedSegment: $selectedSegment,
        options: ["평균 레벨 추이", "필러워드", "말 빠르기"]
    ).frame(width: 300)
}
