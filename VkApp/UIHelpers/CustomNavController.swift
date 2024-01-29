//
//  CustomNavController.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 19.09.2023.
//

import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    let customTransition = CustomTransitionAnimator()
    // переменная для иньеракьиой анимации перехода
    var interactiveTransition: UIPercentDrivenInteractiveTransition?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let swipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(handleSwipe(_:)))
        swipeGestureRecognizer.edges = .left
        view.addGestureRecognizer(swipeGestureRecognizer)

    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customTransition
    }
    
    @objc func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        // это функция для определения абсолютного значения без какого лиьо знака
        let progress = abs(translation.x) / gestureRecognizer.view!.frame.width

        switch gestureRecognizer.state {
        case .began:
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            // Триггер для закрытия экрана
            popViewController(animated: true)
        case .changed:
            interactiveTransition?.update(progress)
        case .ended, .cancelled:
            if progress > 0.5 {
                interactiveTransition?.finish()
            } else {
                interactiveTransition?.cancel()
            }
            interactiveTransition = nil
        default:
            break
        }
    }


}




class CustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5 // Длительность анимации (по желанию)
    }
    // здесь проихсодит анимацция перехода между двумя представлениями на контейере containerView
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // если переход интерактивный то есть происходиь свайп тогда 0.2 иначе вызывается функция
        let duration = transitionContext.isInteractive ? 0.2 : transitionDuration(using: transitionContext)
        // начальное значение fromView и конечное значение toView для перехода при помощи transitionContext, если чего-то нет значит происходит завершение
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to)
        else {
            return
        }

        let containerView = transitionContext.containerView

        // Настройте начальное и конечное состояния представлений
        // здесь происходиь изменение прзрачности toView от нуля до единицы
        toView.alpha = 0.0
        containerView.addSubview(toView)

        UIView.animate(withDuration: duration, animations: {
            toView.alpha = 1.0
        }, completion: { _ in
            // завершение анимации  завершение перехода
            // успещно ли анимация заверешни или неь
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
