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

class MoviePlayerController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton:UIButton!
    @IBOutlet weak var statusLabel:UILabel!
    @IBOutlet weak var totalTimeLabel:UILabel!
    @IBOutlet weak var currentTimeLabel:UILabel!
    @IBOutlet weak var container:UIView!
    var video:Movie?
    var containedViewController:UIViewController?
    var player:AVPlayer?
    var currentStatus = status.Idle
    var audioRec: AVAudioRecorder?
    var audioTracks = [AudioTrack]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Encerrar", style: .Plain, target: self, action:#selector(MoviePlayerController.mixAudioAndVideo))
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
            self.startRecording()
        case .Recording:
            self.currentStatus = .Paused
            videoPlayer.pause()
            self.pauseRecording()
        default:
            self.currentStatus = .Recording
            videoPlayer.play()
            self.startRecording()
        }
        
        self.recordButton.setImage(self.currentStatus.image, forState: .Normal)
        self.statusLabel.text = self.currentStatus.statusLabel
    }
    
    func getVideoCurrentCTime() -> CMTime {
        guard let currentTime = self.player?.currentTime() else {
            return CMTime.init()
        }
        return currentTime
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
    
    func startRecording() {
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let docsDirect = paths[0]
        
        let audioTrack = AudioTrack()
        let audioName = "audio\(self.audioTracks.count).caf"
        audioTrack.audioURL = docsDirect.URLByAppendingPathComponent(audioName)!
        audioTrack.audioTime = self.getVideoCurrentCTime()
        audioTrack.audioName = audioName
        
        self.audioTracks.append(audioTrack)
        
        let audioUrl = try audioTrack.audioURL
        
        //1. create the session
        let session = AVAudioSession.sharedInstance()
        
        if (session.respondsToSelector(#selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    do {
                        // 2. configure the session for recording and playback
                        try session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
                        try session.setActive(true)
                        // 3. set up a high-quality recording session
                        //create AnyObject of settings
                        let settings: [String : AnyObject] = [
                            AVFormatIDKey: Int(kAudioFormatAppleLossless),
                            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
                            AVEncoderBitRateKey : 320000,
                            AVNumberOfChannelsKey: 2,
                            AVSampleRateKey : 44100.0
                        ]
                        // 4. create the audio recording, and assign ourselves as the delegate
                        self.audioRec = try AVAudioRecorder(URL: audioUrl, settings: settings)
                        self.audioRec?.delegate = self
                        self.audioRec?.record()
                    }
                    catch let error {
                        // failed to record!
                        print(error)
                    }
                }
                else {
                    print("not granted")
                }
            })
        }
    }
    
    func pauseRecording() {
        self.audioRec?.pause()
    }
    
    @IBAction func stopRecording() {
        self.audioRec?.stop()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("erro")
        } else {
            print("sucesso")
            self.playMusic()
        }
    }
    
    func playMusic() {
        let audioTrack = self.audioTracks.first
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let docsDirect = paths[0]
        
        let musicFile = docsDirect.URLByAppendingPathComponent(audioTrack!.audioName)
        print(musicFile)
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOfURL: musicFile!)
            audioPlayer.volume = 1.0
            audioPlayer.play()
        } catch let error {
            print(error)
        }
    }
    
    func mixAudioAndVideo() {
        SVProgressHUD.showInfoWithStatus("Exportando video...")
        let mixComposition = AVMutableComposition()
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let docsDirect = paths[0]
        
        for audioTrack in self.audioTracks {
            let musicFile = docsDirect.URLByAppendingPathComponent(audioTrack.audioName)
            let audioAsset = AVURLAsset(URL: musicFile!, options: nil)
            let audioTimeRange = CMTimeRangeMake(audioTrack.audioTime!, audioAsset.duration)
            let compositionAudioTrack:AVMutableCompositionTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
            do {
                try compositionAudioTrack.insertTimeRange(audioTimeRange, ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio).first!, atTime: audioTrack.audioTime!)
            } catch let error {
                print(error)
            }
        }
        
        let videoAsset = AVURLAsset(URL: video!.movieURL, options: nil)
        let videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
        let compositionVideoTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        try! compositionVideoTrack.insertTimeRange(videoTimeRange, ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeVideo).first!, atTime: kCMTimeZero)
        
        
        let videoName = "\(KeychainWrapperManager.getUser()!.uid)-video\(self.audioTracks.count).mov"
        let outputFilePath = docsDirect.URLByAppendingPathComponent(videoName)
        
        let assetExport = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        assetExport!.outputFileType = "com.apple.quicktime-movie"
        assetExport!.outputURL = outputFilePath!
        
        assetExport?.exportAsynchronouslyWithCompletionHandler({ 
            dispatch_async(dispatch_get_main_queue()){
                print("finished exporting")
                SVProgressHUD.dismiss()
            }
        })
    }
}
