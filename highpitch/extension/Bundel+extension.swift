//
//  Bundle+.swift
//  returnzerotest
//
//  Created by musung on 2023/10/10.
//

import Foundation

extension Bundle {
    var returnZeroClientId: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
                fatalError("Couldn't find file 'SecretKey.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "ReturnZero_Client _ID") as? String else {
                fatalError("Couldn't find key 'ReturnZero_Client _ID' in 'SecretKey.plist'.")
            }
            return value
        }
    }
    var returnZeroClientSecret: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
                fatalError("Couldn't find file 'SecretKey.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "ReturnZero_Client_Secret") as? String else {
                fatalError("Couldn't find key 'ReturnZero_Client_Secret' in 'SecretKey.plist'.")
            }
            return value
        }
    }
}
