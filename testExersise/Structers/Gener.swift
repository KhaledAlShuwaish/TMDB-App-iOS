//
//  Gener.swift
//  testExersise
//
//  Created by Khaled Shuwaish on 20/01/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit

struct MyGener : Codable {
    var genres : [Gener]
}
struct Gener : Codable {
    var id : Int
    var name : String
}
