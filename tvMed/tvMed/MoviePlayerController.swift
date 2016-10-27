//
//  MoviePlayerController.swift
//  tvMed
//
//  Created by Vinicius Albino on 25/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation
import MediaPlayer

enum status: String {
    case Idle = "idle"
    case Recording = "recording"
    case Paused = "paused"
    
    var image:UIImage {
        switch self {
        case .Idle:
            return UIImage(named: "record_icon")!
        case .Recording:
            return UIImage(named: "pause_icon")!
        default:
            return UIImage(named: "record_icon")!
        }
    }
    
    var statusLabel:String {
        switch self {
        case .Idle:
            return "Iniciar gravação"
        case .Recording:
            return "Gravando..."
        default:
            return "Pausado"
        }
    }
}

class MoviePlayerController: UIViewController {
    
    @IBOutlet weak var recordButton:UIButton!
    @IBOutlet weak var statusLabel:UILabel!
    @IBOutlet weak var totalTimeLabel:UILabel!
    @IBOutlet weak var currentTimeLabel:UILabel!
    @IBOutlet weak var container:UIView!
    var video:Movie?
    var containedViewController:UIViewController?
    var player:AVPlayer?
    var currentStatus = status.Idle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadVideo()
    }
    
    @IBAction func recordButtonPressed() {
        guard let videoPlayer = self.player else {
            return
        }
        switch self.currentStatus {
        case .Idle:
            self.currentStatus = .Recording
            videoPlayer.play()
        case .Recording:
            self.currentStatus = .Paused
            videoPlayer.pause()
        default:
            self.currentStatus = .Recording
            videoPlayer.play()
        }
        
        self.recordButton.setImage(self.currentStatus.image, forState: .Normal)
        self.statusLabel.text = self.currentStatus.statusLabel
    }
    
    func loadVideo() {
        guard let currentMovie = self.video, let viewController = self.containedViewController else {
            return
        }
        
        self.player = AVPlayer(URL: currentMovie.movieURL)
        self.player?.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: nil, usingBlock: { time in
            let currentPlayerItem = self.player!.currentItem
            let duration = currentPlayerItem?.asset.duration
            let currentTime = self.player?.currentTime()
            
            let durationInSeconds = NSTimeInterval(Float(CMTimeGetSeconds(duration!)))
            let currentTimeInSeconds = NSTimeInterval(Float(CMTimeGetSeconds(currentTime!)))
            
            self.currentTimeLabel.text = "Tempo \(currentTimeInSeconds.hourMinuteSecondString)"
            self.totalTimeLabel.text = "Total \(durationInSeconds.hourMinuteSecondString)"
        })
        let playerPreviewView = PlayerPreviewView(frame: CGRectZero)
        viewController.view.addSubview(playerPreviewView)
        playerPreviewView.player = self.player
        self.player?.muted = true
        playerPreviewView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": playerPreviewView]))
        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": playerPreviewView]))
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier != nil else {
            return
        }
        if segue.identifier == "moviePlayerController" {
            self.containedViewController = segue.destinationViewController as UIViewController
        }
    }
}
