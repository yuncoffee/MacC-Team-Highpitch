//
//  HPTooltip.swift
//  highpitch
//
//  Created by yuncoffee on 10/17/23.
//

import SwiftUI

struct HPTooltip<T: View>: View {
    @State
    private var isPopoverActive = false
    var tooltipContent: String
    var content: (() -> T)?
    var completion: (() -> Void)?
    
    var body: some View {
        Button {
            isPopoverActive.toggle()
            if let completion = completion {
                completion()
            }
        } label: {
            Label("도움말", systemImage: "questionmark.circle")
                .systemFont(.footnote)
                .labelStyle(.iconOnly)
                .foregroundStyle(Color.HPGray.system400)
                .frame(width: 20, height: 20)
        }
        .buttonStyle(.plain)
        .popover(isPresented: $isPopoverActive, content: {
            if let content {
                content()
            } else {
                Text(tooltipContent)
                    .padding(.HPSpacing.xsmall)
            }
//            (content ?? <#default value#>)()
            
//            if let content = content {
//                
//            } else {
//
            
//            }
//            ZStack {
//                Color("F6F6F6")
//                VStack(alignment: .leading, spacing: .HPSpacing.xxxxsmall) {
//                    Text("회차별 연습 차트란?")
//                        .systemFont(.footnote, weight: .bold)
//                    VStack(alignment: .leading, spacing: 0) {
//                        HStack(spacing: 0) {
//                            Text("이 프로젝트에서 연습한")
//                                .systemFont(.caption, weight: .regular)
//                            Text("모든 회차들의 레벨 변화와 습관어 사용")
//                                .systemFont(.caption, weight: .semibold)
//                        }
//                        HStack(spacing: 0) {
//                            Text("비율 변화, 평균 발화 속도의 추이")
//                                .systemFont(.caption, weight: .semibold)
//                            Text("를 한 눈에 볼 수 있게 각각 차트")
//                                .systemFont(.caption, weight: .regular)
//                        }
//                        HStack(spacing: 0) {
//                            Text("로 나타냈어요.")
//                                .systemFont(.caption, weight: .regular)
//                        }
//                    }
//                    Text("* 차트의 점을 클릭하면, 해당 회차의 연습 날짜 및 시간 정보를 볼 수 있어요")
//                        .systemFont(.caption2, weight: .medium)
//                        .foregroundStyle(Color.HPPrimary.base)
//                }
//                .padding(.HPSpacing.xsmall)
//            }
        })
    }
}

extension HPTooltip where T == EmptyView {
    init(tooltipContent: String, completion: (() -> Void)?) {
        self.init(
            tooltipContent: tooltipContent,
            content: {EmptyView()},
            completion: completion
        )
    }
    
    init(tooltipContent: String) {
        self.init(tooltipContent: tooltipContent, content: nil, completion: nil)
    }
}

#Preview {
    HPTooltip(tooltipContent: "도움말", completion: nil)
}
