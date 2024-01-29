//
//  FotosRequest.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 06.10.2023.
//

import Foundation

struct FotosRequest: Decodable {
    var response: FotosRequestItemsCount
}

struct FotosRequestItemsCount: Decodable {
    var count: Int
    var items: [FotosRequestDateSizes]
}

struct FotosRequestDateSizes: Decodable {
    var date: Date
    var sizes: [SizesUrl]
}

struct SizesUrl: Decodable {
    var url: String
}
