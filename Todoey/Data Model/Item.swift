//
//  Item.swift
//  Todoey
//
//  Created by Agus Hernandez on 1/23/19.
//  Copyright © 2019 Agus Hernandez. All rights reserved.
//

import Foundation

/* Codable, Encodable, Decodable classes should ouly contain properties that are standard data types (Strings, Bool, etc) not custom objects */
class Item: Codable /* Encodable, Decodable are included in codable*/ {
    var title: String = ""
    var done: Bool = false
}
