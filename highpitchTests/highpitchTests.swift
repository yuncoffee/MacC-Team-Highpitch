//
//  highpitchTests.swift
//  highpitchTests
//
//  Created by yuncoffee on 10/10/23.
//

import XCTest

final class HighpitchTests: XCTestCase {

    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAuthManagerExample() async throws {
        let authManager = AuthManager()
        try await authManager.signUp(userName: "musung3", userId: "musung3", userPw: "12345")
        try await authManager.login(userId: "musung3", userPw: "12345")
        let keychainManager = KeychainManager()
        let token = try keychainManager.load(forKey: .authToken)
        print(token)
        XCTAssertNotNil(token)
    }
    
    func testKeychainManagerExample() async throws {
        let keychainManager = KeychainManager()
        let authToken = "123"
        let tokenData = TokenData(token: "123111", expried: Date.now)
        try keychainManager.save(data: authToken, forKey: .authToken)
        try keychainManager.save(data: tokenData, forKey: .rzToken)
        let load = try keychainManager.load(forKey: .authToken)
        let loadTokenData = try keychainManager.load(forKey: .rzToken)
        
        XCTAssert(authToken == load as? String)
        XCTAssert(tokenData == loadTokenData as? TokenData)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
