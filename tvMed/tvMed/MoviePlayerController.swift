//
//  MoviePlayerController.swift
//  tvMed
//
//  Created by Vinicius Albino on 25/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation
import MediaPlayer

class MoviePlayerController: UIViewController {
    
    @IBOutlet weak var container:UIView!
    var video:Movie?
    var containedViewController:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadVideo()
    }
    
    func loadVideo() {
        guard let currentMovie = self.video, let viewController = self.containedViewController else {
            return
        }
        
        let player: AVPlayer = AVPlayer(URL: currentMovie.movieURL)
        
        let playerPreviewView = PlayerPreviewView(frame: CGRectZero)
        viewController.view.addSubview(playerPreviewView)
        playerPreviewView.player = player
        
        playerPreviewView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": playerPreviewView]))
        viewController.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": playerPreviewView]))
        player.play()
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
