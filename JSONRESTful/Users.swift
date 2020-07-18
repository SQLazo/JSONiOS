//
//  Users.swift
//  JSONRESTful
//
//  Created by Emerson on 7/17/20.
//  Copyright © 2020 Emerson. All rights reserved.
//

import Foundation

struct Users:Decodable {
    let id:Int
    let nombre:String
    let clave:String
    let email:String
}
