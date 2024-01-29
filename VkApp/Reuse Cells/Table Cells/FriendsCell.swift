//
//  FriendsCell.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 18.06.2023.
//

import UIKit

class FriendsCell: UITableViewCell {
    
    @IBOutlet var friendsView: AvatarImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var animateAction: (() -> Void)?
    
    func configure(friend: FriendsResponseInfoRealm) {
        self.friendsView.image = UIImage(named: "Паспорт Кокорин")
        self.nameLabel.text = "\(friend.firstName) \(friend.lastName)"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateView))
        friendsView.addGestureRecognizer(tapGesture)
        friendsView.isUserInteractionEnabled = true
    }
    
    @objc
    func animateView() {
        animateAction?()
    }
}
