//
//  PlayerPreviewView.swift
//  tvMed
//
//  Created by Vinicius Albino on 25/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class PlayerPreviewView: UIView {
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.videoGravity = AVLayerVideoGravityResize
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playerLayer.videoGravity = AVLayerVideoGravityResize
    }
    
}
