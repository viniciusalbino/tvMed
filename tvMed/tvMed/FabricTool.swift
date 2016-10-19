//
//  FabricTool.swift
//  tvMed
//
//  Created by Vinicius Albino on 18/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

class FabricTracker: ThirdPartyTool {
    class func loadTool(application: UIApplication) {
        Fabric.with([Crashlytics.sharedInstance()])
    }
}
