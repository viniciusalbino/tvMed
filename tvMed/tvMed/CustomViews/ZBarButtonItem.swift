//
//  ZBarButtonItem.swift
//  Zattini
//
//  Created by Christopher John Morris on 8/4/15.
//  Copyright (c) 2015 Netshoes. All rights reserved.
//

import Foundation

public class ZBarButtonItem: UIBarButtonItem {
    override init() {
        super.init()
        initializeView()
    }
    
    class func barButtonItem(title: String?, style: UIBarButtonItemStyle, target: AnyObject?, action: Selector) -> ZBarButtonItem {
        let button = ZBarButtonItem(title: title, style: style, target: target, action: action)
        button.initializeView()
        return button
    }
    
    class func barButtonItem(barButtonSystemItem systemItem: UIBarButtonSystemItem, target: AnyObject?, action: Selector)  -> ZBarButtonItem {
        let button = ZBarButtonItem(barButtonSystemItem: systemItem, target: target, action: action)
        button.initializeView()
        return button
    }
    
    convenience init(customView: UIView, target: AnyObject, action: Selector) {
        self.init(customView: customView)
        customView.addTarget(target, action: action)
        initializeView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    func initializeView() {
        self.tintColor = UIColor.blackColor()
        self.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16)], forState: .Normal)
    }
}