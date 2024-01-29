//
//  FriendsRequest.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 05.10.2023.
//

import Foundation

struct FriendsRequest: Decodable {
    var response: FriendsResponseCount
}

struct FriendsResponseCount: Decodable {
    var count: Int
    var items: [FriendsResponseInfo]
}

struct FriendsResponseInfo: Decodable {
    var id: Int
    var firstName: String
    var lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case id
    }
}
