//
//  MovieCell.swift
//  tvMed
//
//  Created by Vinicius Albino on 19/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation

enum movieStatus {
    case Download
    case Upload
    case Downloaded
    
    var image:UIImage {
        switch self {
        case .Download:
            return UIImage(named: "cloud_download")!
        case .Upload:
            return UIImage(named: "cloud_upload")!
        default:
            return UIImage(named: "check")!
        }
    }
}

class MovieCell:UITableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var statusView:UIView!
    @IBOutlet weak var downloadButton:UIButton!
    
    func fill(movie:Movie, status: movieStatus) {
        self.titleLabel.text = movie.movieName
        self.downloadButton.setBackgroundImage(status.image, forState: .Normal)
    }
}
