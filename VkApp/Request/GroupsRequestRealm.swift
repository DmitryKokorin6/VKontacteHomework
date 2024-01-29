//
//  GroupsRequestRealm.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 03.11.2023.
//

import Foundation
import Realm
import RealmSwift

class GroupsRequestRealm: Object {
    @Persisted
    var response: GroupsRequestCountItemRealm?
}

class GroupsRequestCountItemRealm: Object {
    @Persisted
    var count: Int
    @Persisted
    var items: List<GroupsRequestNameRealm>
}

class GroupsRequestNameRealm: Object {
    @Persisted
    var name: String = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
