//
//  LoadingProtocol.swift
//  Zazcar
//
//  Created by Vinicius Albino on 17/02/16.
//  Copyright © 2016 Concrete Solutions. All rights reserved.
//

import Foundation

protocol LoadingProtocol {
    func startLoading()
    func stopLoading()
}

extension LoadingProtocol {
    func startLoading() {
        SVProgressHUD.setBackgroundColor(UIColor.clearColor())
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Clear)
    }
    
    func stopLoading() {
        SVProgressHUD.dismiss()
    }
}
