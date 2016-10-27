//
//  NSTimerInterval+Extension.swift
//  tvMed
//
//  Created by Vinicius Albino on 27/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation

import Foundation

extension NSTimeInterval {
    
    /// Returns a `String` representation of the hour/minute or minute/second
    /// value of the receiver.
    ///
    /// If the receiver is greater than 1 hour, will return "X hr X min".
    /// If the receiver is less than 1 hour, will return "X min X sec".
    var hourMinuteSecondString: String {
        get {
            let selfInSeconds = Int(self)
            
            let hours = selfInSeconds / 3600
            
            let hoursString = "Hr"
            let minutesString = "Min"
            let secondsString = "Seg"
            
            if hours >= 1 {
                let minutes = (selfInSeconds % 3600) / 60
                let seconds = selfInSeconds % 60
                
                if minutes > 0 {
                    return "\(hours):\(minutes):\(seconds)"
                }
                else {
                    return "\(hours) \(hoursString)"
                }
            }
            else {
                let minutes = selfInSeconds / 60
                
//                if minutes >= 1 {
                    let seconds = selfInSeconds % 60
                    
                    if seconds > 0 {
                        return "\(minutes):\(seconds)"
                    }
                    else {
                        return "\(minutes) \(minutesString)"
                    }
//                }
//                else {
//                    return "\(selfInSeconds) \(secondsString)"
//                }
            }
        }
    }
}
