import Foundation
import Security


enum RZError: String,Error{
    case NetworkErr
    case JsonParsingErr
    case FileNonExist
}
struct TokenData: Codable{
    var token:String
    var expried:Date
}
struct Result1{
    let utternces:[Utterance]
}
struct Utterance: Codable {
    let startAt: Int
    let duration: Int
    let msg: String
    let spk: Int
}



//1. auth
//2. 토큰 발급 받기
//3. 파일 + 세팅
//4. 오디오 결과값 받기
// 서비스의 역할 = 오디오 -> 오디오 결과값 받기
//1. 인증 받기
    // 토큰 없음 -> 토큰 저장 keychichain 조회 했을 때 없음
    // 토큰 만료 -> 토큰 업데이트 api 호출 했을 때 만료 exception 발생하면 토큰 재 등록
    // 인증 -> 다음 단계
//func
    //1. auth throws -> token 반환
    //2. isAuth throws -> bool 인증이 되었는지 확인 및 업데이트

//2. 파일 확인 및 transcribeId 호출
    // 인증 확인
    // 경로에 파일 있는지 확인 -> 없으면 exception 던짐
    // 파일의 transcribeId 있는지 확인
        // 없으면 토큰과 함께 api 호출 -> transcribeId 받음
        // 오디오 파일 + transcribeId swiftData로 저장
//func
    // 1. 파일 확인 func
    // 2. settranscribe throws -> transcribeId 반환
    // 3. 오디오 파일 + transcribeId 저장 func
//3. transcribeId로 transcribe 모델 반환
    // 인증 확인
    // transcribeId로 api 호출
    // transcribing중이면
    // stream으로 계속 호출하면서 완료 됬는지 알려줌
    // 완료 되면 transcribe 호출
//func
    // transcribe api 호출 func
    // transcribing 중인지 확인하는 func

// 사용자가 파일을 전달 -> transcribe 정보 리턴
    //exception
        // 파일 없음
        // 네트워크 exception
struct ReturnzeroAPI {
    let keyChainManager = KeychainManager()
    let ReturnZero_CLIENT_ID = Bundle().returnZeroClientId
    let ReturnZero_CLIENT_SECRET = Bundle().returnZeroClientSecret
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

        let bodyData = "client_id=\( ReturnZero_CLIENT_ID)&client_secret=\(ReturnZero_CLIENT_SECRET)"

        request.httpBody = bodyData.data(using: .utf8)
        
        
        let (data,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else{
            throw RZError.NetworkErr
        }
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let token = jsonObject["access_token"] as? String,
              let expired = jsonObject["expire_at"] as? Double
        else{
            print("err")
            throw RZError.JsonParsingErr
        }
        return TokenData(token: token, expried: Date(timeIntervalSince1970: expired))
    }
    
    private func isAuth() async throws -> String{
         guard let token = try keyChainManager.load(forKey: .rzToken) as? TokenData else{
             throw RZError.NetworkErr
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
        if(!fileExists(atPath: filePath)) {throw RZError.FileNonExist}
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
            throw RZError.NetworkErr
        }
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let transcribeId = jsonObject["id"] as? String else{
            throw RZError.JsonParsingErr
        }
        return transcribeId

    }
    // 파일 경로 -> 트랜스크라이브만 반환
    private func getTranscribe(transId: String) async throws -> [Utterance]?{
        let jwtToken = try await isAuth()
        guard let url = URL(string: tranUrl + "/" + "\(transId)") else{
            throw RZError.JsonParsingErr
        }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Set the Authorization header with your JWT token
            request.setValue("Bearer \(String(describing: jwtToken))", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "accept")
            
            
            let (data,response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else{
                throw RZError.NetworkErr
            }
            guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
                throw RZError.JsonParsingErr
            }
            guard let status = jsonObject["status"] as? String else{
                throw RZError.JsonParsingErr
            }
            if(status == "completed"){
                guard let results = jsonObject["results"] as? [String: Any],
                      let utterances = results["utterances"] as? [[String: Any]] else {
                    throw RZError.JsonParsingErr
                }
                var utteranceList = try utterances.map { utterance in
                    guard let startAt = utterance["start_at"] as? Int,
                           let duration = utterance["duration"] as? Int,
                           let msg = utterance["msg"] as? String,
                          let spk = utterance["spk"] as? Int else{
                        throw RZError.JsonParsingErr
                    }
                    return Utterance(startAt: startAt, duration: duration, msg: msg, spk: spk)
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
        throw RZError.NetworkErr
    }
}
