//
//  MoviesViewController.swift
//  Flix
//
//  Created by Jose Zindia on 10/17/19.
//  Copyright © 2019 Jose Zindia. All rights reserved.
//

import UIKit
import AlamofireImage


class MoviesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var movies = [[String:Any]]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        //in the url you need to write your own api key:
        //https://api.themoviedb.org/3/movie/now_playing?api_key=putYourAPIKeyHere
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
              self.movies = dataDictionary["results"] as! [[String: Any]]
              self.tableView.reloadData()
              print(self.movies)

           }
        }
        task.resume()
        // Do any additional setup after loading the view.
    }
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell

    }
    
}
    
