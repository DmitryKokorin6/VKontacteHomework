//
//  Session.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 29.09.2023.
//

import Foundation

final class Session {
    var token: String = "vk1.a.pRSAnjjOHin_-R_YfhTDvx3QLdO70fOtzrBPSxxtAiRstUGoAlJboi4fT1hXamVMeMc4c14T_5M-M1jhmYESSJuooH1eWHSygW9nFynJYK0UwUs_OTxDt2bhUG9E582r_N6U_E80e5xTQaDj0GJ2rU6lvMiCjUwuqnTIMS10lvy949ZJuWv9nNoWX3oc5je9G3Sgd5WLJZ2f7nAQoXaHHg"
    var userId: String = "125261895"
    
    static let instance = Session()
    
    private init() { }
}
