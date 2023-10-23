import Foundation
import Security



struct ReturnzeroAPIV2 {
    let keyChainManager = KeychainManager()
    let returnZero_CLIENT_ID = Bundle().returnZeroClientId
    let returnZero_CLIENT_SECRET = Bundle().returnZeroClientSecret
    let authUrl = "http://10.141.49.220:8080/authenticate"
  let tranUrl = "http://10.141.49.220:8080/transcribe"
    
    func getResult(filePath: String)async throws -> [Utterance] {
        let id = try await setTranscribe(filePath: filePath)
        return try await waitForAPIResult(transId: id)
    }
    
    func getToken() async throws -> TokenData {
        var request = URLRequest(url: URL(string: authUrl)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyData = "client_id=\( returnZero_CLIENT_ID)&client_secret=\(returnZero_CLIENT_SECRET)"
        
        request.httpBody = bodyData.data(using: .utf8)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            print(response)
            throw RZError.networkErr
        }
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let token = jsonObject["access_token"] as? String,
              let expired = jsonObject["expire_at"] as? Double
        else {
            print("err")
            throw RZError.jsonParsingErr
        }
        return TokenData(token: token, expried: Date(timeIntervalSince1970: expired))
    }
    
    private func isAuth() async throws -> String {
        // MARK: 여기다!!!!!!!!여기다!!!!!!!!여기다!!!!!!!!여기다!!!!!!!!여기다!!!!!!!!
        do{
            if let token = try keyChainManager.load(forKey: .rzToken) as? TokenData {
                if(Date.now.compare(token.expried).rawValue < 0) {
                    return token.token
                } else {
                    let accessToken = try await getToken()
                    try keyChainManager.save(data: accessToken, forKey: .rzToken)
                    return accessToken.token
                }
            }
            throw RZError.networkErr
        }catch {
            print("here")
            let accessToken = try await getToken()
            try keyChainManager.save(data: accessToken, forKey: .rzToken)
            return accessToken.token
        }
    }
    private func fileExists(atPath path: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
    }
    
    func setTranscribe(filePath: String) async throws -> String {
        if(!fileExists(atPath: filePath)) {throw RZError.fileNonExist}
        let audioURL = URL(filePath: filePath)
        let jwtToken = try await isAuth()
        
        // Set your server URL

        
        var request = URLRequest(url: URL(string: tranUrl)!)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add text data to the request
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"jwtToken\"\r\n\r\n".data(using: .utf8)!)
        body.append(jwtToken.data(using: .utf8)!)
        
        // Add audio file data to the request
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(audioURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
        body.append(try! Data(contentsOf: audioURL))
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            print(response)
            throw RZError.networkErr
        }
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let transcribeId = jsonObject["id"] as? String else {
            throw RZError.jsonParsingErr
        }
        
        print(jsonObject)
        return transcribeId
        
    }
    // 파일 경로 -> 트랜스크라이브만 반환
    private func getTranscribe(transId: String) async throws -> [Utterance]? {
        let jwtToken = try await isAuth()
        print(transId)
        guard let url = URL(string: tranUrl + "/" + transId) else {
            throw RZError.jsonParsingErr
        }
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"jwt\"\r\n\r\n".data(using: .utf8)!)
        body.append(jwtToken.data(using: .utf8)!)
                
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw RZError.networkErr
        }
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            print("11")
            throw RZError.jsonParsingErr
        }
        guard let status = jsonObject["status"] as? String else {
            print(jsonObject)
            throw RZError.jsonParsingErr
        }
        if(status == "completed") {
            guard let results = jsonObject["results"] as? [String: Any],
                  let utterances = results["utterances"] as? [[String: Any]] else {
                throw RZError.jsonParsingErr
            }
            let utteranceList = try utterances.map { utterance in
                guard let startAt = utterance["start_at"] as? Int,
                      let duration = utterance["duration"] as? Int,
                      let message = utterance["msg"] as? String
                else {
                    throw RZError.jsonParsingErr
                }
                return Utterance(startAt: startAt, duration: duration, message: message)
            }
            return utteranceList
        } else {
            return nil
        }
    }
    private func waitForAPIResult(transId: String) async throws -> [Utterance] {
        var elapsedTime: TimeInterval = 0
        while elapsedTime < 60 {
            let start = Date()
            if let result = try? await getTranscribe(transId: transId) {
                return result
            }
            let end = Date()
            elapsedTime += end.timeIntervalSince(start)
            try await Task.sleep(nanoseconds: 3_000_000_000) // 3초 간격으로 API 호출
        }
        throw RZError.networkErr
    }
}
