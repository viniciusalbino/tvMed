//
//  FirebaseToolLoader.swift
//  tvMed
//
//  Created by Vinicius Albino on 16/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation
import Firebase

class FirebaseToolLoader: ThirdPartyTool {
    
    static func loadTool(application: UIApplication) {
        FIRApp.configure()
    }
}
