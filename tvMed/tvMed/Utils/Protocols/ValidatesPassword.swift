//
//  ValidatesPassword.swift
//  tvMed
//
//  Created by Vinicius Albino on 16/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation

protocol ValidatesPassword {
    func isPasswordValid(password: String) -> Bool
}

extension ValidatesPassword {
    func isPasswordValid(password: String) -> Bool {
        
        guard password.length() > 0 else {
            return false
        }
        
        if password.length() <= 3 {
            return false
        }
        else {
            return true
        }
    }
}
