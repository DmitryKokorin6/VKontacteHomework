//
//  GroupsRequest.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 06.10.2023.
//

import Foundation

struct GroupsRequest: Decodable {
    var response: GroupsRequestCountItem
}

struct GroupsRequestCountItem: Decodable {
    var count: Int
    var items: [GroupsRequestName]
}

struct GroupsRequestName: Decodable {
    var name: String
}
