//
//  Movies.swift
//  testExersise
//
//  Created by Khaled Shuwaish on 19/01/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit

struct  MovieResult: Codable {
    var results: [Movie]
}
struct MovieCastResult : Codable{
    var cast : [Movie]  
}
struct Movie: Codable {
    let id: Int
    var vote_average : Double
    var title : String
    var poster_path : String?
    var overview : String
    var genre_ids : [Int]
}

