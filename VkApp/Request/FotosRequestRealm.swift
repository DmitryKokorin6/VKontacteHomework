//
//  FotosRequestRealm.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 05.11.2023.
//

import Foundation
import RealmSwift

class FotosRequestRealm: Object {
    @Persisted
    var response: FotosRequestItemsCountRealm?
}

class FotosRequestItemsCountRealm: Object {
    @Persisted
    var count: Int
    @Persisted
    var items: List<FotosRequestDateSizesRealm>
}

class FotosRequestDateSizesRealm: Object {
    @Persisted
    var date: Date
    @Persisted
    var sizes: List<SizesUrlRealm>
}

class SizesUrlRealm: Object {
    @Persisted
    var url: String = ""
    override class func primaryKey() -> String? {
        return "url"
    }
}
