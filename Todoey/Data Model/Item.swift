//
//  Item.swift
//  Todoey
//
//  Created by Agus Hernandez on 1/25/19.
//  Copyright © 2019 Agus Hernandez. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var paretCategory = LinkingObjects(fromType: Category.self, property: "items")
}
