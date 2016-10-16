//
//  AnnotatedTextField.swift
//  Zattini
//
//  Created by Christopher John Morris on 7/21/15.
//  Copyright (c) 2015 Concrete Solutions. All rights reserved.
//

import Foundation
import UIKit

let kAnnotatedTextFieldAnnotationColor = UIColor(red: 54/255, green: 61/255, blue: 66/255, alpha: 1)
class AnnotatedTextField: UITextField {
    
    var annotationLabel = UILabel()
    var heightConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "text")
    }
    
    func initializeView() {
        self.addTarget(self, action: "textChanged:", forControlEvents: .EditingChanged)
        self.addObserver(self, forKeyPath: "text", options: .New, context: nil)
        self.contentVerticalAlignment = .Bottom
        annotationLabel = createAnnotationLabel()
        annotationLabel.accessibilityIdentifier = "annotated_text_field.uilabel.annotation_label"
        self.addSubview(annotationLabel)
        addConstraints()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "text" {
            self.textChanged(self)
        }
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(super.textRectForBounds(bounds), UIEdgeInsets(top: 0, left: 0, bottom: 7, right: 0))
    }
    
    func textChanged(textField: UITextField) {
        if let text = textField.text {
            if text.characters.count > 0 {
                self.validate()
            }
            toggleAnnotationVisibility(text.characters.count > 0)
        }
    }
    
    /// Shows the annotation label that appears about the user's input.
    /// If the annotationLabel is showing and the argument is true, the
    /// animation is not executed because it animates the input text,
    /// which is not desired.
    func toggleAnnotationVisibility(show: Bool) {
        if self.annotationLabel.alpha == 1 && show {
            return
        }
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: [], animations: {
            self.heightConstraint.constant = show ? 11 : 0
            self.annotationLabel.alpha = show ? 1 : 0
            self.annotationLabel.layoutIfNeeded()
            }, completion: nil)
    }
    
    func createAnnotationLabel() -> UILabel {
        let label = UILabel()
        label.text = self.placeholder
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.font = UIFont.systemFontOfSize(10)
        label.textColor = kAnnotatedTextFieldAnnotationColor
        label.alpha = 0
        label.accessibilityIdentifier = "annotated_text_field.uilabel.label";
        return label
    }
    
    func addConstraints() {
        let views = ["annotationLabel": annotationLabel]
        let metrics = ["height": 0, "leftInset": self.borderStyle == .RoundedRect ? 7 : 0, "verticalInset": 8]
        
        let vertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-verticalInset-[annotationLabel(height)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        heightConstraint = vertical[1] 
        let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-leftInset-[annotationLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        self.addConstraints(vertical)
        self.addConstraints(horizontal)
        self.updateConstraints()
    }
    
    /// Paints the text field as "invalid"
    func invalidate() {
        textColor = UIColor.redColor()
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        annotationLabel.textColor = UIColor.redColor()
    }
    
    /// Paints the text field as "valid", i.e., its standard appearance.
    func validate() {
        textColor = UIColor.blackColor()
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSForegroundColorAttributeName: UIColor(white: 0.7, alpha: 1)])
        annotationLabel.textColor = kAnnotatedTextFieldAnnotationColor
    }
    
    /// Verifies whether text field has been invalidated visually. This is independent of
    /// whether the text inside the text field is valid.
    func isInvalidated() -> Bool {
        return textColor == UIColor.redColor()
    }
}
