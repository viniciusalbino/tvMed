//
//  KeyboardToolbar.swift
//  Zattini
//
//  Created by Christopher John Morris on 7/16/15.
//  Copyright (c) 2015 Concrete Solutions. All rights reserved.
//

import UIKit

@objc public protocol KeyboardToolbarDelegate: NSObjectProtocol {
    optional func toolbar(toolbar: KeyboardToolbar, didClickDone done: ZBarButtonItem, textField: UITextField)
    optional func toolbar(toolbar: KeyboardToolbar, didClickNext next: ZBarButtonItem, textField: UITextField)
    optional func toolbar(toolbar: KeyboardToolbar, didClickPrevious previous: ZBarButtonItem, textField: UITextField)
}

public class KeyboardToolbar: UIToolbar {
    public var toolbarDelegate: KeyboardToolbarDelegate?
    var textField = UITextField()
    var shouldShowFocusButtons = Bool()
    
    public init(textField: UITextField, delegate: KeyboardToolbarDelegate, shouldShowFocusButtons: Bool) {
        self.textField = textField
        self.toolbarDelegate = delegate
        self.shouldShowFocusButtons = shouldShowFocusButtons
        super.init(frame: CGRectZero)
        initializeView()
    }
    
    public init(textField: UITextField, shouldShowFocusButtons: Bool) {
        self.textField = textField
        self.shouldShowFocusButtons = shouldShowFocusButtons
        super.init(frame: CGRectZero)
        initializeView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    private func initializeView() {
        self.barStyle = .Default
        self.tintColor = UIColor.whiteColor()
        let fullToolbar = [fixedSpaceForLastButton(), last(), fixedSpaceBetweenLastAndNextButtons(), next(), seperator(), done()]
        self.items = shouldShowFocusButtons ? fullToolbar : [seperator(), done()]
        self.sizeToFit()
    }
    
    private func last() -> ZBarButtonItem {
        return ZBarButtonItem(customView: LeftPointingArrow(), target: self, action: "last:")
    }
    
    private func next() -> ZBarButtonItem {
        return ZBarButtonItem(customView: RightPointingArrow(), target: self, action: "next:")
    }
    
    private func fixedSpaceForLastButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        button.width = -(Arrow.defaultFrame().size.width / 2)
        return button
    }
    
    private func fixedSpaceBetweenLastAndNextButtons() -> UIBarButtonItem {
        let button = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        button.width = Arrow.defaultFrame().size.width
        return button
    }
    
    private func seperator() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    }
    
    private func done() -> ZBarButtonItem {
        return ZBarButtonItem(title: "OK", style: .Done, target: self, action: "done:")
    }
    
    // MARK: - Actions
    
    public func done(button: ZBarButtonItem) {
        if let delegate = toolbarDelegate where delegate.respondsToSelector(Selector("toolbar:didClickDone:textField:")) {
            delegate.toolbar?(self, didClickDone: button, textField: textField)
            return
        }
        textField.resignFirstResponder()
        textField.sendActionsForControlEvents(.EditingChanged)
    }
    
    public func last(button: ZBarButtonItem) {
        toolbarDelegate?.toolbar?(self, didClickPrevious: button, textField: textField)
    }
    
    public func next(button: ZBarButtonItem) {
        toolbarDelegate?.toolbar?(self, didClickNext: button, textField: textField)
    }
}