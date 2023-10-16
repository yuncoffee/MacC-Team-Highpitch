//
//  KeynoteManager.swift
//  highpitch
//
//  Created by yuncoffee on 10/12/23.
//

import Foundation

/// 키노트 데이터를 관리하는 매니저 클래스
@Observable
final class KeynoteManager {
    /// keynote가 현재 열려있는지 확인하기 위한 멤버변수
    var isKeynoteProcessOpen = false
    var opendKeynotes: [OpendKeynote] = []
//    var myModles: [MyModel] = []
}
