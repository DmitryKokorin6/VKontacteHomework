//
//  FullImageViewController.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 05.09.2023.
//

import UIKit

class FullImageViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var leftImageView: UIImageView!
    @IBOutlet var centerImageView: UIImageView!
    @IBOutlet var rightImageView: UIImageView!
        
    var photos: [UIImage?] = []// Здесь храните фотографии из вашей коллекции
    
    var currentIndex: Int = 0 // Текущий индекс фотографии
        
    var initialCenterImageViewCenter: CGPoint!
    var finalCenterImageViewCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialCenterImageViewCenter = centerImageView.center
        // Настройте начальное отображение фотографий
        updateImageViews()
        
        // Добавьте обработчики жестов для перелистывания
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeftGesture.direction = .left
        
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        self.centerImageView.addGestureRecognizer(swipeGesture)
        
        // Do any additional setup after loading the view.
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp))
        swipeUpGesture.direction = .up
        self.centerImageView.addGestureRecognizer(swipeUpGesture)
        swipeUpGesture.delegate = self
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDownGesture.direction = .down
        self.centerImageView.addGestureRecognizer(swipeDownGesture)
        swipeDownGesture.delegate = self
    }
    
    func updateImageViews() {
        centerImageView.image = photos[currentIndex]
        
        // Убедитесь, что индексы в пределах допустимых значений
        // если идекс ьудеь меньше нуля чьо ьыиь не можеь индекс ьудеь 0 и значиь эьо левое
        let leftIndex = max(currentIndex - 1, 0)
        // чьоьы не ьыло ошиьки ьо есиь чьоьы индекс не превысил числа элеменьов мдддива здесь выьираеься минималное значние
        let rightIndex = min(currentIndex + 1, photos.count - 1)
        
        leftImageView.image = photos[leftIndex]
        rightImageView.image = photos[rightIndex]
    }
    
    @objc func handleSwipe(_ gesture: UIPanGestureRecognizer) {
          switch gesture.state {
          case .began:
              initialCenterImageViewCenter = centerImageView.center
          case .changed:
              let translation = gesture.translation(in: centerImageView)
              centerImageView.center.x = initialCenterImageViewCenter.x + translation.x
          case .ended:
              let velocity = gesture.velocity(in: centerImageView)
              if velocity.x > 0 {
                  if currentIndex > 0 {
                      currentIndex -= 1
                  }
              } else if velocity.x < 0 {
                  if currentIndex < photos.count - 1 {
                      currentIndex += 1
                  }
              }
              finalCenterImageViewCenter = view.center
          
              
                 // Анимируйте уход центрального изображения в зависимости от направления свайпа
                 let animationDuration: TimeInterval = 0.3
                 if velocity.x > 0 {
                     UIView.animate(withDuration: animationDuration) {
                         self.centerImageView.center.x = self.view.bounds.width * 2
                     }
                 } else if velocity.x < 0 {
                     UIView.animate(withDuration: animationDuration) {
                         self.centerImageView.center.x = -self.view.bounds.width * 2
                     }
                 }
                 
                 // После завершения анимации установите следующее изображение в центр
                 DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                     self.centerImageView.center = self.finalCenterImageViewCenter
                     self.updateImageViews()
                 }
          default:
              break
          }
      }

       
       @objc func handleSwipeLeft() {
           // Обработка жеста свайпа влево
           // если не индекс не заключинельный
           // можно поспоьреиь чьо дальше
           if currentIndex < photos.count - 1 {
               currentIndex += 1
               
               finalCenterImageViewCenter = centerImageView.center
               
               centerImageView.center.x += view.bounds.width
               
               UIView.animate(withDuration: 0.9) {
                   self.centerImageView.center = self.finalCenterImageViewCenter
               } completion: { _ in
                   self.updateImageViews()
               }

           }
       }
       
       @objc func handleSwipeRight() {
           // Обработка жеста свайпа вправо
          // если индекс не первый ьогда можно посмоьреиь прдыдущую
           if currentIndex > 0 {
               currentIndex -= 1
               finalCenterImageViewCenter = centerImageView.center
               
               centerImageView.center.x -= view.bounds.width
               
               UIView.animate(withDuration: 0.9) {
                   self.centerImageView.center = self.finalCenterImageViewCenter
               } completion: { _ in
                   self.updateImageViews()
               }
           }
       }

 
    
    @objc func handleSwipeUp() {
        UIView.animate(withDuration: 0.3) {
            let scale = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.centerImageView.transform = scale
            self.centerImageView.alpha = 0.0
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSwipeDown() {
        UIView.animate(withDuration: 0.3) {
            let scale = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.centerImageView.transform = scale
            self.centerImageView.alpha = 0.0
        }
        navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
