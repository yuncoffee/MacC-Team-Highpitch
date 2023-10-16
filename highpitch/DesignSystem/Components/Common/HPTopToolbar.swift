//
//  HPTopToolbar.swift
//  highpitch
//
//  Created by yuncoffee on 10/17/23.
//

import SwiftUI

struct HPTopToolbar: View {
    
    var title: String
    var subTitle: String?
    var backButtonCompletion: (() -> Void)?
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                if let completion = backButtonCompletion {
                    Button {
                      print("키노트 열기")
                        completion()
                    } label: {
                        Text("키노트 열기")
                            .font(.system(size: 16))
                            .frame(width: 120, height: 40)
                            .foregroundStyle(.white)
                            .background(Color("2f2f2f"))
                            .cornerRadius(10)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, 32)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            Text("\(title)")
                .systemFont(.body)
                .foregroundStyle(Color.HPTextStyle.darkness)
                .frame(maxWidth: .infinity)
            HStack(spacing: 0) {
                Button {
                  print("키노트 열기")
                } label: {
                    Text("키노트 열기")
                        .systemFont(.body)
                        .frame(width: 120, height: 40)
                        .foregroundStyle(Color.HPGray.systemWhite)
                        .background(Color.HPSecondary.base)
                        .cornerRadius(10)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.trailing, 32)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, minHeight: 64)
        .background(Color.HPGray.systemWhite)
        .border(.HPComponent.stroke, width: 1, edges: [.bottom])
    }
}

#Preview {
    HPTopToolbar(title: "프로젝트 이름")
}
