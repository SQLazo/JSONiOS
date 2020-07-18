//
//  Peliculas.swift
//  JSONRESTful
//
//  Created by Emerson on 7/17/20.
//  Copyright © 2020 Emerson. All rights reserved.
//

import Foundation
struct Peliculas:Decodable {
    let usuarioId:Int
    let id:Int
    let nombre:String
    let genero:String
    let duracion:String
}
