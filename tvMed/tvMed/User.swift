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
    
    let uid: String
    let email: String
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
