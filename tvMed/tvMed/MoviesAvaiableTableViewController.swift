//
//  MoviesAvaiableTableViewController.swift
//  tvMed
//
//  Created by Vinicius Albino on 17/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation

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
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell")! as UITableViewCell
        let movie = self.movies[indexPath.row]
        cell.textLabel?.text = movie.movieName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
