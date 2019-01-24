//
//  Cast.swift
//  testExersise
//
//  Created by Khaled Shuwaish on 21/01/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit

struct MyCast : Codable {
    var cast : [Cast]
}
struct Cast : Codable{
    var id : Int
    var name : String
    var profile_path : String?
}
