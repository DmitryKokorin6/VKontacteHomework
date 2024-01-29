//
//  CollectionViewCellTest.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 14.07.2023.
//

import UIKit

class FriendsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var friendsImageView: UIImageView!
    @IBOutlet var controlLike: LikeControl!
    @IBOutlet var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        controlLike = LikeControl(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        //addSubview(controlLike)
    }
    
    func config(friendsImage: UIImage?) {
        self.friendsImageView.image = friendsImage
    }
    

}
