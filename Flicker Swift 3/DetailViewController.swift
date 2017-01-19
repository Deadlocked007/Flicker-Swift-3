//
//  DetailViewController.swift
//  Flicker Swift 3
//
//  Created by Siraj Zaneer on 1/13/17.
//  Copyright © 2017 Siraj Zaneer. All rights reserved.
//

import UIKit
import SwiftyJSON
import AFNetworking

class DetailViewController: UIViewController {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var smallView: UIImageView!
    
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var doge1View: UIImageView!
    @IBOutlet weak var doge2View: UIImageView!
    @IBOutlet weak var doge3View: UIImageView!
    
    @IBOutlet weak var videoView: UIWebView!
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    
    var id: Int?
    
    var movie: Movie?
    
    let lowRes:String = "https://image.tmdb.org/t/p/w45"
    
    var movies: [Movie?] = []
    
    let stepper = UIStepper()
    let number = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard let id = id else {
            let errorAlert = UIAlertController(title: "Error", message: "There was an issue loading the movie please try again later.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
            errorAlert.addAction(ok)
            self.present(errorAlert, animated: true, completion: {
                
            })
            
            return
        }
        setupScrollView()
        loadInfo(id: id)
    }
    
    func setupScrollView() {
        
//        let constant = self.view.frame.size.height - UIApplication.shared.statusBarFrame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - (self.tabBarController?.tabBar.frame.size.height)! - titleLabel.frame.size.height - 10
        //
        //        infoConstraint.constant = constant
        //        // Content size
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 2500)
    }
    
    func loadInfo(id: Int) {
        MovieClient.shared.getMoreInfo(id: id, success: { (json) in
            self.setup(json: json)
        }) { (error) in
            let errorAlert = UIAlertController(title: "Error", message: "There was an issue loading the movie please try again later.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
            errorAlert.addAction(ok)
            self.present(errorAlert, animated: true, completion: {
            })
            
            return
        }
    }
    
    func setup(json: JSON) {
        guard let movie = movie else {
            let errorAlert = UIAlertController(title: "Error", message: "There was an issue loading the movie please try again later.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
            errorAlert.addAction(ok)
            self.present(errorAlert, animated: true, completion: {
                
            })
            
            return
        }
        
        let lowResURL = URL(string: lowRes + movie.image)!
        let imageURL = URL(string: movie.imageURL)!
        print(lowResURL)
        print(imageURL)
        let lowResURLR = URLRequest(url: lowResURL)
        let imageURLR = URLRequest(url: imageURL)
        
        posterView.setImageWith(lowResURLR, placeholderImage: nil, success: { (request, response, image) in
            self.posterView.alpha = 0.0
            self.posterView.image = image
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                
                self.posterView.alpha = 1.0
                
            }, completion: { (sucess) -> Void in
                
                self.posterView.setImageWith(imageURLR, placeholderImage: image, success: { (request, response, finalImage) in
                    
                    self.posterView.image = finalImage
                    
                }, failure: { (request, response, error) in
                    
                    print(error.localizedDescription)
                    
                })
            })
        }) { (request, response, error) in
            
            print(error.localizedDescription)
            
        }
        
        let smallImageURL = URL(string: movie.imageURL)
        smallView.setImageWith(smallImageURL!)
        
        let rating = movie.rating
        ratingLabel.text = "\(rating)/10"
        
        
        if rating > 3.3 {
            doge2View.isHidden = false
        }
        
        if rating > 6.6 {
            doge3View.isHidden = false
        }
        
        titleLabel.text = movie.title
        self.navigationItem.title = movie.title
        localLabel.text = movie.language
        overviewLabel.text = movie.overview
        overviewLabel.adjustsFontSizeToFitWidth = true
        taglineLabel.text = "\"\(json["tagline"].stringValue)\""
        taglineLabel.adjustsFontSizeToFitWidth = true
        
        var genres = ""
        
        let genresJson = json["genres"].arrayValue
        
        for genre in genresJson {
            if genres == "" {
                genres.append(genre["name"].stringValue)
            } else {
                genres.append(", \(genre["name"].stringValue)")
            }
        }
        
        genreLabel.text = genres
        genreLabel.adjustsFontSizeToFitWidth = true
        MovieClient.shared.loadVideo(id: id!, success: { (json) in
            let key = json["key"].stringValue
            let htm = "<!DOCTYPE HTML> <html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:og=\"http://opengraphprotocol.org/schema/\" xmlns:fb=\"http://www.facebook.com/2008/fbml\"> <head></head> <body style=\"margin:0 0 0 0; padding:0 0 0 0;\"> <iframe width=\"375\" height=\"211\" src=\"http://www.youtube.com/embed/\(key)\" frameborder=\"0\"></iframe> </body> </html> ";
            self.videoView.loadHTMLString(htm, baseURL: nil)
        }) { (error) in
            print(error.localizedDescription)
        }

        loadCollectionView()
        
    }
    
    @IBAction func onRate(_ sender: Any) {
        let errorAlert = UIAlertController(title: movie?.title, message: "What would you like to rate this movie?\n\n", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let rate = UIAlertAction(title: "Rate", style: .default) { (alert) in
            //rate()
            MovieClient.shared.rateMovie(id: "\(self.id!)", rating: self.stepper.value)
        }
        
        self.stepper.frame = CGRect(x: 12.0, y: 70, width: 100.0, height: 10.0)
        self.stepper.maximumValue = 10
        self.stepper.minimumValue = 0
        self.stepper.value = 0
        self.stepper.addTarget(self, action: #selector(DetailViewController.rateChange), for: .valueChanged)
        
        number.text = "\(self.stepper.value)"
        number.font = UIFont(name: number.font.fontName, size: 20)
        
        number.frame = CGRect(x: 12 + stepper.bounds.width + 50, y: 70, width: 100.0, height: 50)
        number.sizeToFit()
        
        errorAlert.view.addSubview(stepper)
        errorAlert.view.addSubview(number)
        
        errorAlert.addAction(cancel)
        errorAlert.addAction(rate)
        
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func rateChange() {
        number.text = "\(stepper.value)"
        number.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let cell = sender as! MovieCell
        let vc = segue.destination as! DetailViewController
        if let indexPath = relatedCollectionView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            vc.movie = movie
            vc.id = movie?.id
        }
     }
    
    
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func loadCollectionView() {
        relatedCollectionView.delegate = self
        relatedCollectionView.dataSource = self
        
        loadMovies()
    }
    
    func loadMovies() {
        MovieClient.shared.getMovies(endpoint: "movie/\(id!)/similar", page: 1, success: { (movies) in
            self.movies = self.movies + movies
            self.relatedCollectionView?.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = collectionView.bounds.height
//        return CGSize(width: height / 1.5, height: height)
//    }
//    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(movies.count)
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        guard let movieInfo = movies[indexPath.row] else {
            return cell
        }
        
        // Configure the cell
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
}
