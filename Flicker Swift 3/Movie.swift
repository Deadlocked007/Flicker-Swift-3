//
//  Movie.swift
//  Flicker Swift 3
//
//  Created by Siraj Zaneer on 12/30/16.
//  Copyright © 2016 Siraj Zaneer. All rights reserved.
//

import UIKit
import SwiftyJSON

class Movie: NSObject {
    
    let baseURL = "https://image.tmdb.org/t/p/w600_and_h900_bestv2"
    var image: String = ""
    var title: String = ""
    var imageURL: String = ""
    var overview: String = ""
    var language: String = ""
    var rating: Double = 0.0
    var id: Int = 0
    
    init(json: JSON) {
        title = json["title"].stringValue
        image = json["poster_path"].stringValue
        imageURL = baseURL + image
        overview = json["overview"].stringValue
        language = json["original_language"].stringValue
        rating = json["vote_average"].doubleValue
        id = json["id"].intValue
    }
    
    /*
     {
     "poster_path": "/qjiskwlV1qQzRCjpV0cL9pEMF9a.jpg",
     "adult": false,
     "overview": "A rogue band of resistance fighters unite for a mission to steal the Death Star plans and bring a new hope to the galaxy.",
     "release_date": "2016-12-14",
     "genre_ids": [
     28,
     12,
     14,
     878,
     53,
     10752
     ],
     "id": 330459,
     "original_title": "Rogue One: A Star Wars Story",
     "original_language": "en",
     "title": "Rogue One: A Star Wars Story",
     "backdrop_path": "/tZjVVIYXACV4IIIhXeIM59ytqwS.jpg",
     "popularity": 216.524868,
     "vote_count": 1101,
     "video": false,
     "vote_average": 7.3
     }
     */
}
