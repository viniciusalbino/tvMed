//
//  Movie.swift
//  tvMed
//
//  Created by Vinicius Albino on 18/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation

class Movie: NSObject {
    var movieURL = NSURL()
    var movieName = ""
    
    var filename: String? {
        return movieURL.lastPathComponent
    }
    
    var urlInDocumentsDirectory: NSURL? {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if paths.count > 0 {
            let path = paths[0]
            if let directory = NSURL(string: path), filename = filename {
                let fileURL = directory.URLByAppendingPathComponent(filename)
                return fileURL
            }
        }
        return nil
    }
}
