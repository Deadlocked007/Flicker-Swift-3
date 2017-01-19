//
//  MovieClient.swift
//  Flicker Swift 3
//
//  Created by Siraj Zaneer on 1/19/17.
//  Copyright © 2017 Siraj Zaneer. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON

class MovieClient: NSObject {
    static let shared = MovieClient()
    
    var baseURL = "https://api.themoviedb.org/3/movie/"
    
    let apiKey = "?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    func getMovies(endpoint: String, page: Int, success:@escaping ([Movie?]) -> Void, failure:@escaping (Error) -> Void) {
        let url = URL(string: "\(baseURL)\(endpoint)\(apiKey)&page=\(page)")
        print(url)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            if let data = dataOrNil {
                print(data)
                let json = JSON(data: data)
                print(json)
                let movieJSON = json["results"].arrayValue
                var movies: [Movie?] = []
                
                for movie in movieJSON {
                    movies.append(Movie(json: movie))
                }
                
                success(movies)
            } else if let error = error {
                failure(error)
            }
        })
        task.resume()
    }

    func getMoreInfo(id: Int, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        let url = URL(string: "\(baseURL)\(id)\(apiKey)")
        print(url)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            if let data = dataOrNil {
                print(data)
                let json = JSON(data: data)
                
                success(json)
            } else if let error = error {
                failure(error)
            }
        })
        task.resume()
    }
    
    func loadVideo(id: Int, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        let url = URL(string: "\(baseURL)\(id)/videos\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            if let data = dataOrNil {
                print(data)
                let json = JSON(data: data)
                let video = json["results"][0]
                
                success(video)
            } else if let error = error {
                failure(error)
            }
        })
        task.resume()
    }
}
