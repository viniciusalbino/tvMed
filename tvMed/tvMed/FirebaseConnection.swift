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

typealias MoviesCallbackClosure = ([Movie]?) -> ()

class FirebaseConnection: NSObject {
    
    class func registerUser(userEmail:String!, userPassword:String!, callback:DefaultCallBackClosure) -> (){
        FIRAuth.auth()?.createUserWithEmail(userEmail, password: userPassword, completion: { user, error in
            callback(User(),self.treatFirebaseError(error))
        })
    }
    
    class func loginUser(userEmail:String!, userPassword:String!, callback:DefaultCallBackClosure) -> () {
        FIRAuth.auth()?.signInWithEmail(userEmail, password: userPassword, completion: { user, error in
            if let firebaseUser = user {
                callback(User(uid: firebaseUser.uid, email: firebaseUser.email!),self.treatFirebaseError(error))
            }
            else {
                callback(User(uid:"sda",email:""),self.treatFirebaseError(error))
            }
        })
    }
    
    class func treatFirebaseError(error:NSError?) -> String? {
        guard let errorTreated = error else {
            return nil
        }
        
        switch errorTreated.code {
        case 17007:
            return "O e-mail já esta sendo utilizado."
        case 17009:
            return "Senha ou usuário incorreto."
        default:
            return "Ocorreu um erro ao registrar o usuário."
        }
    }

    class func getMoviesForUser(user:User, callback: MoviesCallbackClosure) {
        let ref = FIRDatabase.database().referenceWithPath(user.uid)
        
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var movies = [Movie]()
            
            for child in snapshot.children {
                let snapshot = child.children.allObjects as! [FIRDataSnapshot]
                for item in snapshot {
                    
                    let movie = Movie()
                    let movieURL = item.childSnapshotForPath("video") as FIRDataSnapshot
                    let movieName = item.childSnapshotForPath("nome") as FIRDataSnapshot
                    
                    if let tempUrl = movieURL.value as? String, let tempName = movieName.value as? String {
                        if let url = NSURL(string:tempUrl) {
                            movie.movieURL = url
                        }
                        movie.movieName = tempName
                        movies.append(movie)
                    }
                }
            }
            callback(movies)
        })
    }
}
