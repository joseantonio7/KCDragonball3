//
//  SecureDataStoreProtocol.swift
//  IOSAdvanced
//
//  Created by José Antonio Aravena on 30-10-24.
//

import Foundation
@testable import IOSAdvanced

class SecureDataStoreMock: SecureDataStoreProtocol {
    var token = ""
    func set(token: String){
        self.token = token
    }
    func getToken() -> String?{
        return self.token
    }
    func deleteToken(){
        self.token = ""
    }
}
