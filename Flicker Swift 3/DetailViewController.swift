//
//  DetailViewController.swift
//  Flicker Swift 3
//
//  Created by Siraj Zaneer on 1/13/17.
//  Copyright © 2017 Siraj Zaneer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var movie:Movie?
    
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
