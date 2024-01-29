//
//  File.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 02.07.2023.
//

import UIKit

final class GroupImage: UIImageView {
    @IBInspectable var borderColor: CGColor = UIColor.blue.cgColor
    @IBInspectable var borderWidth: CGFloat = 1.0
    
    override func awakeFromNib() {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

final class GroupViewShadow: UIView {
    @IBInspectable var shadowColor: UIColor = .tintColor
    @IBInspectable var shadowRadius: CGFloat = 3.0
    @IBInspectable var shadowOpacity: Float = 0.9
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: -3)
    
    override func awakeFromNib() {
        self.backgroundColor = .clear
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
    }
}
