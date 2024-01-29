//
//  Group.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 27.06.2023.
//

import UIKit

struct Group {
    let avatar: UIImage
    let name: String
}

extension Group: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
}
