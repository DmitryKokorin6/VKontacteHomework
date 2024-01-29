//
//  FriendsRequestRealm.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 25.10.2023.
//

import Foundation
import Realm
import RealmSwift

class FriendsRequestRealm: Object {
    
    @Persisted
    var response: FriendsResponseCountRealm?
}

class FriendsResponseCountRealm: Object {
    
    @Persisted
    var count: Int
    
    @Persisted
    var items = List<FriendsResponseInfoRealm>()
}

class FriendsResponseInfoRealm: Object {
    
    @Persisted
    var id: Int = 0
    
    @Persisted
    var firstName: String = ""
    
    @Persisted
    var lastName: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case id
    }
}

