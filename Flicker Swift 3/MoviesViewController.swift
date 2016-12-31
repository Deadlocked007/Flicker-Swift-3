//
//  MoviesViewController.swift
//  Flicker Swift 3
//
//  Created by Siraj Zaneer on 12/30/16.
//  Copyright © 2016 Siraj Zaneer. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import AFNetworking

class MoviesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var movies: [Movie?] = []
    var tempData: [Movie?] = []
    var filteredData: [Movie?] = []
    
    let errorButton = UIButton(type: UIButtonType.custom)
    let refreshControl = UIRefreshControl()
    var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        // Do any additional setup after loading the view.
        errorButton.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 40)
        errorButton.backgroundColor = UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 0.9)
        errorButton.setTitle("⚠️ Network Error", for: .normal)
        errorButton.isHidden = true
        errorButton.isUserInteractionEnabled = true
        let errorTouch = UITapGestureRecognizer(target: self, action: #selector(MoviesViewController.loadMovies))

        errorButton.addGestureRecognizer(errorTouch)
        self.view.addSubview(self.errorButton)
        collectionView?.delegate = self
        refreshControl.addTarget(self, action: #selector(MoviesViewController.loadMovies), for: UIControlEvents.valueChanged)
        collectionView?.insertSubview(refreshControl, at: 0)
        
        loadMovies()
    }
    
    func loadMovies() {
        if !refreshControl.isRefreshing {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
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
                self.errorButton.isHidden = true
            } else {
                self.errorButton.isHidden = false
                
            }
            self.refreshControl.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
        })
        task.resume()
    }
    
    
    @IBAction func onSearch(_ sender: Any) {
        searchBar = UISearchBar.init(frame: CGRect(x: 0, y: 10, width: (self.navigationController?.navigationBar.bounds.size.width)!, height: (self.navigationController?.navigationBar.bounds.size.height)!/2))
        searchBar!.delegate = self
        searchBar?.showsCancelButton = true
        searchBar!.tag = 1
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        self.navigationController?.navigationBar.addSubview(searchBar!)
        tempData = movies
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        movies = tempData
        filteredData = searchText.isEmpty ? tempData : movies.filter({ (movie: Movie?) -> Bool in
            let title = movie?.title
            let overview = movie?.overview
            
            return (title?.range(of: searchText, options: .caseInsensitive) != nil || overview?.range(of: searchText, options: .caseInsensitive) != nil)
        })
        
        movies = filteredData
        
        collectionView!.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        movies = tempData
        collectionView!.reloadData()
        searchBar.resignFirstResponder()
        self.navigationItem.rightBarButtonItem?.customView?.isHidden = false
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.0, green: 122.0/225.0, blue: 1.0, alpha: 1.0)
        self.navigationController?.navigationBar.viewWithTag(1)?.removeFromSuperview()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.bounds.width / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    
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
        
        // Configure the cel
        cell.posterView.setImageWith(URLRequest(url: URL(string: movieInfo.imageURL)!), placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
            if imageResponse != nil {
                print("Image was NOT cached, fade in image")
                cell.posterView.alpha = 0.0
                cell.posterView.image = image
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    cell.posterView.alpha = 1.0
                })
            } else {
                print("Image was cached so just update the image")
                cell.posterView.image = image
            }
        }) { (imageRequest, imageResponse, error) -> Void in
            
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
