//
//  HeaderNewsTableViewCell.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 08.08.2023.
//

import UIKit

class HeaderNewsTableViewCell: UITableViewCell {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
