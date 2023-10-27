//
//  FileSystemManager.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import Foundation

@Observable
final class FileSystemManager {
    
}

extension FileSystemManager {
    func getCreationMetadata(_ path: String) -> String {
        var result = ""
        
        if let url = URL(string: path) {
            let _path = url.path
            if let mditem = MDItemCreate(nil, _path as CFString),
               let mdnames = MDItemCopyAttributeNames(mditem),
               let mdattrs = MDItemCopyAttributes(mditem, mdnames) as? [String:CFString] {
                let temp = mdattrs["kMDItemFSCreationDate"]
                if let creation = temp {
                    let _temp = NSString(string: creation)
                    result = _temp.description // CFString -> NSString -> String
                }
            } else {
                print("Can't get attributes for \(_path)")
            }
        }
        return result
    }
}
