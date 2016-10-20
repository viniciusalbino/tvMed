//
//  MoviesAvaiableTableViewController.swift
//  tvMed
//
//  Created by Vinicius Albino on 17/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation
import Alamofire

class MoviesAvaiableTableViewController: UITableViewController, LoadingProtocol {
    
    var movies = [Movie]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.startLoading()
        self.getVideos()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vídeos"
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
        self.downloadMovie(movie) { (progress, error) in
            print(error)
        }
    }
    
    func isMovietDownloaded(movie: Movie) -> Bool {
        if let path = movie.urlInDocumentsDirectory?.path {
            let fileManager = NSFileManager.defaultManager()
            return fileManager.fileExistsAtPath(path)
        }
        return false
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
//                print(totalBytesRead)
                dispatch_async(dispatch_get_main_queue()) {
                    let progress = Double(totalBytesRead) / Double(totalBytesExpectedToRead)
                    SVProgressHUD.showProgress(Float(progress))
                    completionHandler(progress, nil)
                }
            }
            .response { request, response, _, error in
                print(response)
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
                print("fileURL: \(destination(NSURL(string: "")!, response!))")
        }
    }
}
