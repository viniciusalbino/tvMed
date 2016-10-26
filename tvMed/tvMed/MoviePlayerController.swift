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
        switch self.currentStatus {
        case .Idle:
            self.currentStatus = .Recording
        case .Recording:
            self.currentStatus = .Paused
        default:
            self.currentStatus = .Recording
        }
        
        self.recordButton.setImage(self.currentStatus.image, forState: .Normal)
        self.statusLabel.text = self.currentStatus.statusLabel
    }
    
    func loadVideo() {
        guard let currentMovie = self.video, let viewController = self.containedViewController else {
            return
        }
        
        self.player = AVPlayer(URL: currentMovie.movieURL)
        
        let playerPreviewView = PlayerPreviewView(frame: CGRectZero)
        viewController.view.addSubview(playerPreviewView)
        playerPreviewView.player = self.player
        
        playerPreviewView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": playerPreviewView]))
        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": playerPreviewView]))
        self.player!.play()
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
