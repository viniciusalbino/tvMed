//
//  BaseControllerProtocol.swift
//  Zazcar
//
//  Created by Vinicius Albino on 17/02/16.
//  Copyright © 2016 Concrete Solutions. All rights reserved.
//

import Foundation

protocol BaseControllerProtocol {
    func addBackButton()
    func handleBack(button:UIButton)
    func closeView()
    func setupDismissButton()
}

extension UIViewController : BaseControllerProtocol {
    func addBackButton() {
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: "back_button"), style: .Plain, target: self, action: Selector("handleBack:"))
        backButton.tintColor = UIColor.blackColor()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func handleBack(button:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func closeView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupDismissButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: NSLocalizedString("Fechar", comment: ""), style: .Plain, target: self, action: Selector("closeView"))
    }
}