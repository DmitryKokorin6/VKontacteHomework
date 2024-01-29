//
//  NewsTableViewCell.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 06.08.2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet var userTextLabel: UILabel!
    @IBOutlet var userNewsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
//    func configure( userImage: UIImage,
//                    userName: String,
//                    userText: String,
//                    userNews: UIImage,
//                    userLike: UIButton ) {
//        self.userImageView.image = userImage
//        self.userLikeButton = userLike
//        self.userNameLabel.text = userName
//        self.userNewsImageView.image = userImage
//        self.userTextLabel.text = userText
//    }
    
}
