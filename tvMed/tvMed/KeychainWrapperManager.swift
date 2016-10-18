//
//  KeychainWrapper.swift
//  tvMed
//
//  Created by Vinicius Albino on 17/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation

class KeychainWrapperManager: NSObject {
    
    class func checkLoggedUser() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        guard let _ = userDefaults.valueForKey("user") else {
            return false
        }
        return true
    }
    
    class func saveUser(user:User) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(user.getUserDict(), forKey: "user")
        userDefaults.synchronize()
    }
    
    class func deleteUser() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("user")
        userDefaults.synchronize()
    }
    
    class func getUser() -> User? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        guard let userDict = userDefaults.valueForKey("user") else {
            return nil
        }
        return User.parseUser(userDict as! NSDictionary)
    }
}
