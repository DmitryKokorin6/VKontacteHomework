import UIKit

class CircularLoaderView: UIView {
    private var circleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularLayer()
    }
    
    private func createCircularLayer() {
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
            radius: frame.size.width / 2,
            startAngle: -.pi / 2,
            endAngle: 3 * .pi / 2,
            clockwise: true
        )
        
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor.blue.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 3.0
        circleLayer.strokeEnd = 0.0
        
        layer.addSublayer(circleLayer)
    }
    
    func startAnimation(completion: @escaping () -> Void) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 2.0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.circleLayer.removeAllAnimations()
            completion()
        }
        
        circleLayer.add(animation, forKey: "animateCircle")
        CATransaction.commit()
    }
}

