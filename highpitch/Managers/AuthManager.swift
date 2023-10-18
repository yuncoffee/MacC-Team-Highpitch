//
//  AuthManager.swift
//  highpitch
//
//  Created by musung on 10/17/23.
//

import Foundation
enum AuthError:Error {
    case networkErr
    case jsonParsingErr
}
struct AuthManager {
    let keychainManager = KeychainManager()
    let baseUrl = "http://localhost:8080"
    
    private func getToken(userId:String, userPw:String) async throws -> String {
       var request = URLRequest(url: URL(string: baseUrl + "/login")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "user_id": userId,
            "user_pw": userPw
        ]

        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
       
       let (data,response) = try await URLSession.shared.data(for: request)
       guard let httpResponse = response as? HTTPURLResponse,
             httpResponse.statusCode == 200 else {
           throw AuthError.networkErr
       }
       guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
             let token = jsonObject["user_token"] as? String
       else {
           print("err")
           throw AuthError.jsonParsingErr
       }
       return token
   }
    func login(userId: String, userPw: String)async throws {
        let token = try await getToken(userId: userId, userPw: userPw)
        try keychainManager.save(data: token, forKey: .authToken)
    }
    func signUp(userName:String,userId:String, userPw:String) async throws {
        var request = URLRequest(url: URL(string: baseUrl + "/signUp")!)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")

         let requestBody: [String: Any] = [
            "userName": userName,
             "userId": userId,
             "userPw": userPw
         ]

         let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
         request.httpBody = jsonData
        
        let (_,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AuthError.networkErr
        }
    }
}
