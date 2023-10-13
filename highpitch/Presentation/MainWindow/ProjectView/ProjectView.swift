//
//  ProjectView.swift
//  highpitch
//
//  Created by yuncoffee on 10/13/23.
//

import SwiftUI

/**
 전체 연습 통계
 전체 연습 통계 UI 그리기
 프로젝트 불러오기
 특정 키노트 열기
 연습 횟수 불러오기
 연습 기간 불러오기
 평균 레벨 출력하기
 가장 높게 평가된 연습 회차 정보로 이동 버튼 기능
 평균 레벨 추이 그래프
 필러워드 그래프
 말 빠르기 그래프
 */

struct ProjectView: View {
    @Environment(ProjectManager.self)
    private var projectManager
    
    var body: some View {
        VStack {
            Text("Hello, \(projectManager.current?.projectName ?? "none")")
            PracticeView()
        }
    }
}

#Preview {
    ProjectView()
}
