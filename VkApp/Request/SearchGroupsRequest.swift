//
//  SearchGroupsRequest.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 09.10.2023.
//

import Foundation

struct SearchGroupsRequest: Decodable {
    var response: SearchGroupsCountItems
}

struct SearchGroupsCountItems: Decodable {
    var count: Int
    var items: [SearchGroupsName]
}

struct SearchGroupsName: Decodable {
    var name: String
}
