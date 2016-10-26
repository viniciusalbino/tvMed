//
//  MoviesAvaiableTableViewController.swift
//  tvMed
//
//  Created by Vinicius Albino on 17/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation
import Alamofire
import MediaPlayer
import MobileCoreServices
import Photos

class MoviesAvaiableTableViewController: UITableViewController, LoadingProtocol, AVAudioRecorderDelegate {
    
    var movies = [Movie]()
    var audioRec: AVAudioRecorder?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.startLoading()
        self.getVideos()
        self.startRecordingWithMicrophone()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vídeos"
    }
    
    func startRecordingWithMicrophone() {
        AVAudioSession.sharedInstance().requestRecordPermission () {
            [unowned self] allowed in
            if allowed {
                // Microphone allowed, do what you like!
//                self.startRecording()
            } else {
                // User denied microphone. Tell them off!
                
            }
        }
    }
    
    func getVideos() {
        if let user = KeychainWrapperManager.getUser() {
            FirebaseConnection.getMoviesForUser(user, callback: { movies in
                self.stopLoading()
                guard let tempMovies = movies else {
                    return
                }
                self.movies = tempMovies
                self.tableView.reloadData()
            })
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Vídeos disponíveis"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCell
        let movie = self.movies[indexPath.row]
        cell.fill(movie, status: self.isMovietDownloaded(movie) ? movieStatus.Downloaded : movieStatus.Download)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let movie = self.movies[indexPath.row]
        if self.isMovietDownloaded(movie) {
            self.showOptionsToVideo(movie)
        }
        else {
            self.downloadMovie(movie) { (progress, error) in
                
            }
        }
    }
    
    func showOptionsToVideo(movie:Movie) {
        
        let alert = UIAlertController(title: "Editar",
                                      message: "Opções",
                                      preferredStyle: .ActionSheet)
        
        let editAction = UIAlertAction(title: "Editar Video",
                                       style: .Default) { action in
//        let moviePlayer = MPMoviePlayerViewController(contentURL: movie.movieURL)
//        self.presentMoviePlayerViewControllerAnimated(moviePlayer)
                                        self.performSegueWithIdentifier("showMovieSegue", sender: movie)
        }
        
        let deleteAction = UIAlertAction(title: "Deletar Video Local",
                                         style: .Default) { action in
            self.deleteLocalMovie(movie)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .Destructive) { action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.navigationController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func isMovietDownloaded(movie: Movie) -> Bool {
        if let path = movie.urlInDocumentsDirectory?.path {
            let fileManager = NSFileManager.defaultManager()
            return fileManager.fileExistsAtPath(path)
        }
        return false
    }
    
    func deleteLocalMovie(movie:Movie) {
        if let path = movie.urlInDocumentsDirectory?.path {
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.removeItemAtURL(NSURL(string: path)!)
                self.tableView.reloadData()
            }catch let error{
                print(error)
            }
        }
    }
    
    func downloadMovie(movie: Movie, completionHandler: (Double?, NSError?) -> Void) {
        guard isMovietDownloaded(movie) == false else {
            completionHandler(1.0, nil) // already have it
            self.tableView.reloadData()
            return
        }
        
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        Alamofire.download(.GET, movie.movieURL, destination: destination)
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                dispatch_async(dispatch_get_main_queue()) {
                    let progress = Double(totalBytesRead) / Double(totalBytesExpectedToRead)
                    SVProgressHUD.showProgress(Float(progress))
                    completionHandler(progress, nil)
                }
            }
            .response { request, response, _, error in
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
//                print("fileURL: \(destination(NSURL(string: "")!, response!))")
        }
    }
    
    func startRecording() {
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let docsDirect = paths[0]
        
        let audioUrl = try docsDirect.URLByAppendingPathComponent("audioFileName.m4a")
        
        //1. create the session
        let session = AVAudioSession.sharedInstance()
        
        do {
            // 2. configure the session for recording and playback
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
            try session.setActive(true)
            // 3. set up a high-quality recording session
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
            ]
            // 4. create the audio recording, and assign ourselves as the delegate
            audioRec = try AVAudioRecorder(URL: audioUrl!, settings: settings)
            audioRec?.delegate = self
            audioRec?.record()
        }
        catch let error {
            // failed to record!
            print(error)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
//            recordingEnded(success: false)
        } else {
//            recordingEnded(success: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier != nil else {
            return
        }
        if segue.identifier == "showMovieSegue", let movieViewController = segue.destinationViewController as? MoviePlayerController {
            movieViewController.video = sender as? Movie
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MoviesAvaiableTableViewController: UIImagePickerControllerDelegate {
}

// MARK: - UINavigationControllerDelegate
extension MoviesAvaiableTableViewController: UINavigationControllerDelegate {
}
