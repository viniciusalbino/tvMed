//
//  ThirdPartyToolLoaders.swift
//  tvMed
//
//  Created by Vinicius Albino on 16/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation
import UIKit

protocol ThirdPartyTool {
    static func loadTool(application: UIApplication)
}

class ThirdPartyToolsLoader: NSObject {
    
    private static let _sharedInstance = ThirdPartyToolsLoader()
    
    class func sharedInstance() -> ThirdPartyToolsLoader {
        return _sharedInstance
    }
    
    func loadTools(application: UIApplication) {
        FirebaseToolLoader.loadTool(application)
    }
}
