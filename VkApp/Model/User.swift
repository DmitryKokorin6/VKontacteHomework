//
//  User.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 27.06.2023.
//

import UIKit

struct User {
    let avatar: UIImage
    let name: String
    var isAnimating: Bool = false
    
    init(avatar: UIImage, name: String) {
        self.avatar = avatar
        self.name = name
    }
}

//
//extension User: Equatable {
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.name == rhs.name
//    }
//}
