//
//  Details.swift
//  testExersise
//
//  Created by Khaled Shuwaish on 21/01/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit

struct Details : Codable {
    var id : Int
    var genres : [Gener]
    var imdb_id : String
    var poster_path : String
    var title : String
    var overview : String
    var vote_average : Double
}


