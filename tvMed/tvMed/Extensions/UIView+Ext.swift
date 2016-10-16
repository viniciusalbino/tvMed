//
//  UIView+Ext.swift
//  Zattini
//
//  Created by Christopher John Morris on 8/4/15.
//  Copyright (c) 2015 Netshoes. All rights reserved.
//

import Foundation

extension UIView {
    func addTarget(target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action )
        tap.numberOfTapsRequired = 1;
        self.addGestureRecognizer(tap)
    }
}
