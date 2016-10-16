//
//  TextFieldFirstResponderBouncer.swift
//  Zazcar
//
//  Created by Vinicius Albino on 24/02/16.
//  Copyright © 2016 Concrete Solutions. All rights reserved.
//

import Foundation

class TextFieldFirstResponderBouncer: NSObject {

    class func bounceTextFieldForwards(textField:UITextField, textFields:[UITextField]) {
        let index = textFields.indexOf(textField)! + 1
        guard index < textFields.count else {
            return
        }
        textFields[index].becomeFirstResponder()
    }
    
    class func bounceTextFieldBackwards(textField:UITextField, textFields:[UITextField]) {
        let index = textFields.indexOf(textField)! - 1
        guard index < textFields.count else {
            return
        }
        textFields[index].becomeFirstResponder()
    }
}