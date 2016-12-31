//
//  MoviesViewController.swift
//  Flicker Swift 3
//
//  Created by Siraj Zaneer on 12/30/16.
//  Copyright © 2016 Siraj Zaneer. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import MBProgressHUD

class MoviesViewController: UICollectionViewController {

    var movies: [Movie?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false


        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadMovies(refreshControl:)), for: UIControlEvents.valueChanged)
        collectionView?.insertSubview(refreshControl, at: 0)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        loadMovies(refreshControl: nil)
    }
    
    func loadMovies(refreshControl: UIRefreshControl?) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            if let data = dataOrNil {
                self.movies = []
                let json = JSON(data: data)
                let movieJSON = json["results"].arrayValue
                for movie in movieJSON {
                    self.movies.append(Movie(json: movie))
                }
                self.collectionView?.reloadData()
            }
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
        task.resume()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        guard let movieInfo = movies[indexPath.row] else {
            return cell
        }
    
        // Configure the cell
    
        Alamofire.request(movieInfo.imageURL).responseImage { response in
            guard let image = response.result.value else {
                print("error downloading image")
                return
            }
            cell.posterView.image = image
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
