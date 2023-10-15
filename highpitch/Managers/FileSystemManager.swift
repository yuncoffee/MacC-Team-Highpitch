//
//  FileSystemManager.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import Foundation

@Observable
final class FileSystemManager {
    
    // MARK: 임시로 번들 데이터 가져와서 프로젝트 구성하였음
    func loadProjects() -> [Project] {
        var result: [Project] = []
        
        /// --- Test1
        let TEST_ONE_KEY = Bundle.main.url(forResource: "test1", withExtension: "key")
        let TEST_ONE_M4A = Bundle.main.url(forResource: "test1", withExtension: "m4a")
        let TEST_ONE_JSON = Bundle.main.url(forResource: "test1", withExtension: "json")
        /// --- Test2
        let TEST_TWO_KEY = Bundle.main.url(forResource: "test2", withExtension: "key")
        let TEST_TWO_M4A = Bundle.main.url(forResource: "test2", withExtension: "m4a")
        let TEST_TWO_JSON = Bundle.main.url(forResource: "test2", withExtension: "json")
        
        var project1 = Project(
            projectName: "test1",
            creatAt: Data().description,
            keynotePath: TEST_ONE_KEY,
            practices: []
        )
        
        var project2 = Project(
            projectName: "test2",
            creatAt: Data().description,
            keynotePath: TEST_TWO_KEY,
            practices: []
        )
        
        for index in 0...1 {
            do {
                let data = try Data(contentsOf: index == 0 ? TEST_ONE_JSON! : TEST_TWO_JSON!)
                let decoder = JSONDecoder()
                let jsonModel = try decoder.decode(SampleProjectJson.self, from: data)
                var practice = Practice(
                    audioPath: index == 0 ? TEST_ONE_M4A! : TEST_TWO_M4A!,
                    utterances: []
                )
                
                jsonModel.utterances.forEach { utterance in
                    practice.utterances.append(Utterance(
                        startAt: utterance.startAt,
                        duration: utterance.duration,
                        message: utterance.message
                    ))
                }

                if index == 0 {
                    project1.practices.append(practice)
                } else {
                    project2.practices.append(practice)
                    project2.practices.append(practice)
                }
            } catch {
                print("파일 또는 디코딩 에러")
            }
        }
        result.append(project1)
        result.append(project2)
        
        return result
    }
}
