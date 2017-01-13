//
//  DetailViewController.swift
//  Flicker Swift 3
//
//  Created by Siraj Zaneer on 1/13/17.
//  Copyright © 2017 Siraj Zaneer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterView: UIImageView!
    var movie:Movie?
    
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
        
        setup(movie: movie)
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
