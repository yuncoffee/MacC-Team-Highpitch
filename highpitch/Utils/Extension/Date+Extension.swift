//
//  ChartUtils.swift
//  highpitch
//
//  Created by yuncoffee on 10/13/23.
//

import Foundation

extension Date {
    // MARK: Date.now()를 기준으로 YYYYMMDDHHMMSS.m4a 형식의 String으로 변환
    func makeM4aFileName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter.string(from: Date())
    }
    
    // MARK: MediaManager밑에 있는 fileName을 통해서 createAt에 넣을 날짜 생성
    func m4aNameToCreateAt(input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyyMMddHHmmss"
        
        if let date = inputFormatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
            
            let formattedDate = outputFormatter.string(from: date)
            
            return formattedDate
        } else {
            return "Invalid Date"
        }
    }
    
    // MARK: createAt의 날짜를 통해서 연습 탭에 띄울 날짜 생성
    func createAtToPracticeDate(input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        
        if let date = inputFormatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "YYYY.MM.dd(E) HH:mm:ss"
            outputFormatter.locale = Locale(identifier: "ko_KR")
            
            let dateString = outputFormatter.string(from: date)
            
            return dateString
        } else {
            return "Invalid Date"
        }
    }
    
}
