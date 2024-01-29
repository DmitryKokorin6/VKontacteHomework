//
//  TestVC.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 29.06.2023.
//


import UIKit

final class TestVC: UIViewController {

    private let someView: UIView = SomeRootView(frame: CGRect(x: 100.0, y: 100.0, width: 160.0, height: 160.0))
    
    @IBOutlet var someButton: UIButton!
    var isLike = false
    
    @IBAction func buttonPress(_ sender: Any) {
        //        let login = loginTextField.text
        //        let password = passwordTextField.text
        //
        // Отключаем кнопку, чтобы избежать повторных нажатий
        //        button.isEnabled = false
        
        // Анимация уменьшения кнопки и скрытия текста
        UIView.animate(withDuration: 0.3, animations: {
            self.someButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.someButton.setTitle("", for: .normal)
        }) { _ in
            // Вычисляем конечный размер кружка загрузки
            let finalSize = self.someButton.frame.size.height
            
            // Показываем кружок загрузки
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = self.someButton.center
            activityIndicator.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            // Анимация увеличения кружка загрузки до размера кнопки
            UIView.animate(withDuration: 0.3) {
                activityIndicator.transform = CGAffineTransform(scaleX: finalSize / activityIndicator.frame.size.width, y: finalSize / activityIndicator.frame.size.height)
            } completion: { _ in
                // По окончании анимации переходите на следующий экран
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        someView.layer.borderColor = UIColor.red.cgColor
        someView.layer.borderWidth = 10
        someView.layer.cornerRadius = someView.frame.width / 2
        someView.clipsToBounds = true
        someView.layer.shadowRadius = 6
        someView.layer.shadowColor = UIColor.green.cgColor
        someView.layer.shadowOpacity = 0.9
        someView.layer.shadowOffset = CGSize(width: 10, height: 10)
        
    }
    
    private func config() {
        view.addSubview(someView)
        print(someView)
    }
    
    private func transform() {
        let transform = CGAffineTransform(translationX: 100, y: 100)
        let scale = CGAffineTransform(scaleX: 2, y: 2)
        let rotation = CGAffineTransform(rotationAngle: .pi / 4)
        // объединить трансформации concatenationg
        someView.transform = transform
            .concatenating(scale)
            .concatenating(rotation)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.someView.transform = .identity
        }
        // если нужно чтобы трансформация была друг за другом
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.someView.transform = scale
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.someView.transform = rotation
//        }
    }
    

}

class SomeRootView: UIView {
    
    override class var layerClass: AnyClass {
        CALayer.self
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
//        context.fill(CGRect(
//            x: 100.0,
//            y: 100.0,
//            width: 150.0,
//            height: 150.0))
//        context.setFillColor(UIColor.red.cgColor)
        context.setStrokeColor(UIColor.red.cgColor)
        let path = UIBezierPath.someBezier().cgPath
        context.addPath(path)
        context.strokePath()
    }
}
