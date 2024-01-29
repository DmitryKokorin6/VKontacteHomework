//
//  FileNew.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 14.06.2023.
//
import UIKit

class NewClass: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var keyTextField: UITextField!
    
    @IBOutlet weak var someButton: UIButton!
    
    @IBAction func buttonPress() {
//        transform()
        
        UIView.animate(
            withDuration: 3) {
                self.someButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.someButton.setTitle("", for: .normal)
            } completion: { _ in
                let activityIndicator = UIActivityIndicatorView()
                activityIndicator.center = self.someButton.center
                activityIndicator.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                
                let finalState = self.someButton.frame.size.height
                
                UIView.animate(
                    withDuration: 3) {
                        activityIndicator.transform = CGAffineTransform(
                            scaleX: finalState / activityIndicator.frame.size.width,
                            y: finalState / activityIndicator.frame.size.height)
                    } completion: { _ in
                        self.performSegue(withIdentifier: "goToTest", sender: nil)
                    }
            }
    }
    
//    @IBAction func pressButton(_ sender: Any) -> Bool {
//        view.backgroundColor = UIColor(red: 1.3, green: 0.5, blue: 1, alpha: 0.5)
//
//        if !userInfo() {
//            warringTable()
//            return true
//        } else {
//            return warringTable()
//        }
//
//    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
//    
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        switch identifier {
//        case
//        }
//    }
    
    func userInfo() {
        loginTextField.text = "admin"
        keyTextField.text = "123"
    }
    
    
    func warringTable() {
        let warringTable = UIAlertController(
            title: "Ошибка",
            message: "Неверные данные",
            preferredStyle: .alert)
        
        let letsGo = UIAlertAction(title: "Отмена", style: .cancel)
        warringTable.addAction(letsGo)
        present(warringTable, animated: true)
    }
    
}
