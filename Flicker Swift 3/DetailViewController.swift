//
//  DetailViewController.swift
//  Flicker Swift 3
//
//  Created by Siraj Zaneer on 1/13/17.
//  Copyright © 2017 Siraj Zaneer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var infoConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var movie:Movie?
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var smallView: UIImageView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var doge1View: UIImageView!
    @IBOutlet weak var doge2View: UIImageView!
    @IBOutlet weak var doge3View: UIImageView!
    
    @IBOutlet weak var videoView: UIWebView!
    
    let lowRes:String = "https://image.tmdb.org/t/p/w45"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        setupScrollView()
        setup(movie: movie)
    }
    
    func setupScrollView() {

        let constant = self.view.frame.size.height - UIApplication.shared.statusBarFrame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - (self.tabBarController?.tabBar.frame.size.height)! - titleLabel.frame.size.height - 10
        
        infoConstraint.constant = constant
        // Content size
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 2500)
    }

    func setup(movie: Movie) {
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


    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
