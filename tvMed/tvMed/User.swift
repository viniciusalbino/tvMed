//
//  User.swift
//  tvMed
//
//  Created by Vinicius Albino on 16/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation
import FirebaseAuth

class User: NSObject {
    
    var uid = ""
    var email = ""
    
    
    func start (authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    override init() {
        super.init()
    }
    
    convenience init(uid: String, email: String) {
        self.init()
        self.uid = uid
        self.email = email
    }
    
    func getUserDict() -> NSDictionary {
        return ["uid" : self.uid,
                "email" : self.email]
    }
    
    class func parseUser(dict:NSDictionary) -> User {
        let newUser = User(uid: dict.objectForKey("uid") as! String, email: dict.objectForKey("email") as! String)
        return newUser
    }
    
    func saveUser() {
        KeychainWrapperManager.saveUser(self)
    }
    
    func deleteUser() {
        KeychainWrapperManager.deleteUser()
    }
}
