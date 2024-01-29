//
//  UIBezie + Extention.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 29.06.2023.
//

import UIKit

extension UIBezierPath {
    static func someBezier() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 30, y: 30))
        path.addCurve(to: CGPoint(x: 30, y: 30), controlPoint1: CGPoint(x: 60, y: 60), controlPoint2: CGPoint(x: 90, y: 90))
        path.close()
        return path
    }
}

