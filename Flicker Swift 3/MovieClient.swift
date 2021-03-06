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
    
    var baseURL = "https://api.themoviedb.org/3/"
    
    let apiKey = "?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    func getMovies(endpoint: String, page: Int, success:@escaping ([Movie?]) -> Void, failure:@escaping (Error) -> Void) {
        let url = URL(string: "\(baseURL)\(endpoint)\(apiKey)&page=\(page)")
        print(url)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            if let data = dataOrNil {
                let json = JSON(data: data)
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
        let url = URL(string: "\(baseURL)movie/\(id)\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            if let data = dataOrNil {
                let json = JSON(data: data)
                
                success(json)
            } else if let error = error {
                failure(error)
            }
        })
        task.resume()
    }
    
    func loadVideo(id: Int, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        let url = URL(string: "\(baseURL)movie/\(id)/videos\(apiKey)")
        print(url)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            if let data = dataOrNil {
                let json = JSON(data: data)
                let video = json["results"][0]
                
                success(video)
            } else if let error = error {
                failure(error)
            }
        })
        task.resume()
    }
    
    func loadGenres(success:@escaping ([String], [String]) -> Void, failure:@escaping (Error) -> Void) {
        let url = URL(string: "\(baseURL)genre/movie/list\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            if let data = dataOrNil {
                let json = JSON(data: data)
                let genresJson = json["genres"].arrayValue
                
                var genres: [String] = []
                var ids: [String] = []
                
                for genre in genresJson {
                    genres.append(genre["name"].stringValue)
                    ids.append(genre["id"].stringValue)
                }
                
                success(genres, ids)
            } else if let error = error {
                failure(error)
            }
        })
        task.resume()
    }
    
    func rateMovie(id: String, rating: Double) {
        let url = URL(string: "\(baseURL)/movie/\(id)/rating\(apiKey)")
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let data = "{\"value\": \(rating)}"
        let json = JSON(data)
        
        request.httpMethod = "POST"
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            try request.httpBody = json.rawData()
            
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
        } catch let error as Error {
            print(error.localizedDescription)
        }
    }
}
