//
//  RecordView.swift
//  Highpitch
//
//  Created by Yun Dongbeom on 2023/09/20.
//

import SwiftUI

struct RecordView: View {
    var body: some View {
        VStack {
            Text("프로젝트 명")
            HStack {
                VStack {
                    VStack {
                        Text("평균 연습 소요 시간")
                        Text("00시간 00분")
                        
                    }
                    VStack {
                        Text("총 연습 횟수")
                        Text("00회")
                    }
                }
            }
            VStack {
                Text("연습 기록 다시보기")
                List(0...3, id: \.self) { index in
                    HStack {
                        Text("\(index + 1)")
                        Text(Date().description)
                        Text("00:00")
                    }
                }
            }
            ZStack {
                VStack {
                    HStack {
                        Rectangle()
                        Text("발화 속도가 빠른 구간")
                    }
                    HStack {
                        Rectangle()
                        Text("발화 속도가 느린 구간")
                    }
                }
                Text("첫번째 연습의 발화 속도 체크")
                Text("평균 페이스보다 빠르거나 느리게 말한 부분을 다시 들어보며 체크해보세요.")
                HStack {
                    HStack {
                        Image(systemName: "play")
                        Text("00:00")
                    }
                    HStack {
                        ZStack {
                            HStack {
                                Rectangle()
                            }
                            VStack {
                                Text("00:00")
                                Rectangle()
                                Rectangle()
                            }
                        }
                    }
                    HStack {
                        Text("00:00")
                    }
                }
            }
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
