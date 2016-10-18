//
//  MoviesAvaiableTableViewController.swift
//  tvMed
//
//  Created by Vinicius Albino on 17/10/16.
//  Copyright © 2016 tvMed. All rights reserved.
//

import Foundation

class MoviesAvaiableTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = KeychainWrapperManager.getUser() {
            FirebaseConnection.getMoviesForUser(user, callback: { movies in
//                print(movies)
            })
        }
    }
}
