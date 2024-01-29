//
//  TestTableViewCell.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 25.07.2023.
//

import UIKit

class TestTableViewCell: UITableViewCell {

    @IBOutlet var testLabel: UILabel!
    
    func configure(label: String) {
        testLabel.text = label
    }
    
}
