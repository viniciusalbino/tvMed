//
//  ValidatesUsername.swift
//  Zazcar
//
//  Created by Vinicius Albino on 13/01/16.
//  Copyright © 2016 Concrete Solutions. All rights reserved.
//

import Foundation

protocol ValidatesUsername {
     func isUsernameValid(password: String) -> Bool
}

extension ValidatesUsername {
    func isUsernameValid(username: String) -> Bool {
        
        guard username.length() > 0 else {
            return false
        }
        
        if username.length() <= 3 {
            return false
        }
        else {
            return true
        }
    }
}
