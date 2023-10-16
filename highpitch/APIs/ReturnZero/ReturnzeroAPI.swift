import Foundation
import Security


enum RZError: String, Error {
    case networkErr
    case jsonParsingErr
    case fileNonExist
}
struct TokenData: Codable {
    var token:String
    var expried:Date
}
struct Result1 {
    let utternces:[Utterance]
}
struct ReturnzeroAPI {
    let keyChainManager = KeychainManager()
    let returnZero_CLIENT_ID = Bundle().returnZeroClientId
    let returnZero_CLIENT_SECRET = Bundle().returnZeroClientSecret
    let authUrl = "https://openapi.vito.ai/v1/authenticate"
    let tranUrl = "https://openapi.vito.ai/v1/transcribe"
    
    
    
    func getResult(filePath: String)async throws -> [Utterance]{
        let id = try await setTranscribe(filePath: filePath)
        return try await waitForAPIResult(transId: id)
    }
    
     private func getToken() async throws -> TokenData{
        var request = URLRequest(url: URL(string: authUrl)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyData = "client_id=\( returnZero_CLIENT_ID)&client_secret=\(returnZero_CLIENT_SECRET)"

        request.httpBody = bodyData.data(using: .utf8)
        
        
        let (data,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else{
            throw RZError.networkErr
        }
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let token = jsonObject["access_token"] as? String,
              let expired = jsonObject["expire_at"] as? Double
        else{
            print("err")
            throw RZError.jsonParsingErr
        }
        return TokenData(token: token, expried: Date(timeIntervalSince1970: expired))
    }
    
    private func isAuth() async throws -> String{
         guard let token = try keyChainManager.load(forKey: .rzToken) as? TokenData else{
             throw RZError.networkErr
         }
         if(Date.now.compare(token.expried).rawValue < 0){
             return token.token
         }
         else{
             let accessToken = try await getToken()
             try keyChainManager.save(data: accessToken, forKey: .rzToken)
             return accessToken.token
         }
    }
    //파일이 있는지, 확장자 체크하는 로직
    private func fileExists(atPath path: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
    }
    
    private  func setTranscribe(filePath: String) async throws ->String {
        let apiUrl = tranUrl
        let filePath = filePath
        if(!fileExists(atPath: filePath)) {throw RZError.fileNonExist}
        let jwtToken = try await isAuth()
        // 설정(config) JSON 데이터
        let config: [String: Any] = [
            "use_diarization": true, // 화자 분리
            "diarization": [
                "spk_count": 2 // 참여하는 화자 수 알면 여기다가 적는다.
            ],
            "use_multi_channel": false, // 다중 채널 지원
            "use_itn": false, // 영어 숫자 단위 변환
            "use_disfluency_filter": true, // 간투어 필터 ("에-"는 필터가 되지 않음)
            "use_profanity_filter": false, // 비속어 필터
            "use_paragraph_splitter": true, // 문단 나누기
            "paragraph_splitter": [
                "max": 5 // 한 문단의 최대 글자 수
            ]
        ]
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(String(describing: jwtToken))", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // 파일 데이터 추가
        if let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"fight.m4a\"\r\n".data(using: .utf8)!)
                                                       // ************* filename=\"파일이름.확장자\"~~로 수정
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }

        // 설정(config) JSON 데이터 추가
        if let jsonData = try? JSONSerialization.data(withJSONObject: config, options: []) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"config\"\r\n\r\n".data(using: .utf8)!)
            body.append(jsonData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body
        
        let (data,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else{
            throw RZError.networkErr
        }
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let transcribeId = jsonObject["id"] as? String else{
            throw RZError.jsonParsingErr
        }
        return transcribeId

    }
    // 파일 경로 -> 트랜스크라이브만 반환
    private func getTranscribe(transId: String) async throws -> [Utterance]?{
        let jwtToken = try await isAuth()
        guard let url = URL(string: tranUrl + "/" + "\(transId)") else{
            throw RZError.jsonParsingErr
        }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Set the Authorization header with your JWT token
            request.setValue("Bearer \(String(describing: jwtToken))", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "accept")
            
            
            let (data,response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else{
                throw RZError.networkErr
            }
            guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
                throw RZError.jsonParsingErr
            }
            guard let status = jsonObject["status"] as? String else{
                throw RZError.jsonParsingErr
            }
            if(status == "completed"){
                guard let results = jsonObject["results"] as? [String: Any],
                      let utterances = results["utterances"] as? [[String: Any]] else {
                    throw RZError.jsonParsingErr
                }
                var utteranceList = try utterances.map { utterance in
                    guard let startAt = utterance["start_at"] as? Int,
                           let duration = utterance["duration"] as? Int,
                           let message = utterance["msg"] as? String
                    else{
                        throw RZError.jsonParsingErr
                    }
                    return Utterance(startAt: startAt, duration: duration, message: message)
                }
                return utteranceList
            }
            else{
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
