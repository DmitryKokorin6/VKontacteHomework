//
//  Test.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 04.07.2023.
//

import Foundation

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var leftImage: UIImageView!
    @IBOutlet var centerImage: UIImageView!
    @IBOutlet var rightImage: UIImageView!
    
    var images = [
        UIImage(systemName: "heart"),
        UIImage(systemName: "star"),
        UIImage(systemName: "Паспорт Кокорин")
    ]
    
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeft))
        swipeLeftGesture.direction = .left
        centerImage.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRight))
        swipeRightGesture.direction = .right
        centerImage.addGestureRecognizer(swipeRightGesture)
        
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let button1 = UIButton(type: .system)
        button1.setTitle("Button1", for: .normal)
        
        let button2 = UIButton(type: .system)
        button2.setTitle("Button2", for: .normal)
        
        let button3 = UIButton(type: .system)
        button3.setTitle("Button3", for: .normal)
        
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(button3)
        
        //view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
        
    }
    
    func updateImages() {
        centerImage.image = images[currentIndex]
        
        let leftIndex = max(currentIndex - 1, 0)
        let rightIndex = min(currentIndex + 1, images.count - 1)
        
        leftImage.image = images[leftIndex]
        rightImage.image = images[rightIndex]
    }
    
    @objc
    func handleLeft() {
        if currentIndex < images.count - 1 {
            currentIndex += 1
            updateImages()
        }
    }
    
    @objc
    func handleRight() {
        if currentIndex > 0 {
            currentIndex -= 1
            updateImages()
        }
    }
}
