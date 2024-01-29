//
//  AvatarImage.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 30.06.2023.
//

import UIKit

final class AvatarImageView: UIImageView {
    @IBInspectable var borderColor: CGColor = UIColor.systemPink.cgColor
    @IBInspectable var borderWidth: CGFloat = 1.5
    
    override func awakeFromNib() {
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    

}

final class AvatarShadow: UIView {
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: -3)
    @IBInspectable var shadowOpacity: Float = 0.8
    @IBInspectable var shadowColor: CGColor = UIColor.red.cgColor
    @IBInspectable var shadowRadius: CGFloat = 3

    override func awakeFromNib() {
        self.backgroundColor = .clear
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = shadowColor
        self.layer.shadowRadius = shadowRadius
    }


}

final class UserView: UIView {
    var logoView = UIImageView()
    let shadowView = UIView()
    
    @IBInspectable var shadowColor: UIColor = .green {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 5) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        logoView.frame = rect
        logoView.layer.cornerRadius = shadowRadius
        logoView.clipsToBounds = true
        logoView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        shadowView.frame = rect
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowRadius = shadowRadius 
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        shadowView.layer.shadowOpacity = 0.9
        shadowView.clipsToBounds = false
        shadowView.layer.shadowPath = UIBezierPath(
            roundedRect: shadowView.bounds,
            cornerRadius: shadowRadius).cgPath
        
        shadowView.addSubview(logoView)
        self.addSubview(shadowView)
    }
}
