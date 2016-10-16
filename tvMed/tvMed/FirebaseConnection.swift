//
//  FirebaseConnection.swift
//  tvMed
//
//  Created by Vinicius Albino on 16/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias DefaultCallBackClosure = (User?, String?) -> ()

class FirebaseConnection: NSObject {
    
    class func registerUser(userEmail:String!, userPassword:String!, callback:DefaultCallBackClosure) -> (){
        FIRAuth.auth()?.createUserWithEmail(userEmail, password: userPassword, completion: { user, error in
            callback(User(authData:user!),self.treatFirebaseError(error))
        })
    }
    
    class func loginUser(userEmail:String!, userPassword:String!, callback:DefaultCallBackClosure) -> () {
        FIRAuth.auth()?.signInWithEmail(userEmail, password: userPassword, completion: { user, error in
            callback(User(authData:user!),self.treatFirebaseError(error))
        })
    }
    
    class func treatFirebaseError(error:NSError?) -> String? {
        guard let errorTreated = error else {
            return nil
        }
        
        switch errorTreated.code {
        case 17007:
            return "O e-mail já esta sendo utilizado."
        default:
            return "Ocorreu um erro ao registrar o usuário."
        }
    }
}
