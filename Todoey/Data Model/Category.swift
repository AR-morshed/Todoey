//
//  Category.swift
//  Todoey
//
//  Created by Arman morshed on 14/3/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
    
    
}
