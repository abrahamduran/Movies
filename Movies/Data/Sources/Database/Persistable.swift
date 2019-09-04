//
//  Persistable.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RealmSwift

protocol Persistable {
    associatedtype RealmObject: RealmSwift.Object
    
    init(with object: RealmObject)
    func realmObject() -> RealmObject
}
