//
//  Category.swift
//  
//
//  Created by Agus Hernandez on 1/25/19.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    
    /* List is an REALM object */
    var items = List<Item>()
}
