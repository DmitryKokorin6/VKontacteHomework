//
//  ViewController.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 02.06.2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var button: UIButton!
    
//    @IBAction func buttonPressed(_ sender: Any) {
//        let login = loginTextField.text
//        let password = passwordTextField.text
//    }
    
    private var loaderView: CircularLoaderView!
    

    func animateLogin() {
        UIView.animate(
            withDuration: 3,
            animations: {
                self.loginTextField.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            },
            completion: nil)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let login = loginTextField.text
        let password = passwordTextField.text
        
        // Анимация уменьшения кнопки и скрытия текста
        UIView.animate(withDuration: 0.3, animations: {
            self.button.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.button.setTitle("", for: .normal)
        }) { _ in
            // Создайте CircularLoaderView и добавьте его на экран
            if self.loaderView == nil {
                self.loaderView = CircularLoaderView(frame: self.button.frame)
                self.view.addSubview(self.loaderView)
            }

            
            UIView.animateKeyframes(withDuration: 4.0, delay: 0.0, options: [.autoreverse, .repeat], animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                    self.loaderView.center.x -= self.view.bounds.width / 2
                    self.loaderView.transform = CGAffineTransform(scaleX: 2, y: 2)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                    self.loaderView.center.x += self.view.bounds.width / 2
                    self.loaderView.transform = CGAffineTransform(scaleX: 1, y: 1)

                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
                    self.loaderView.center.x += self.view.bounds.width / 2
                    self.loaderView.transform = CGAffineTransform(scaleX: 2, y: 2)

                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                    self.loaderView.center.x -= self.view.bounds.width / 2
                    self.loaderView.transform = CGAffineTransform(scaleX: 1, y: 1)

                }
                self.loaderView.startAnimation {
                    self.performSegue(withIdentifier: "goToMain", sender: nil)
                }
                
            }, completion: nil)


            // Анимация движения круга влево и вправо
            
                // Движение влево
            
                // По окончании анимации вы можете выполнять необходимые действия
                // Например, переход на следующий экран
            
            
                
        }
    }

        // Отключаем кнопку, чтобы избежать повторных нажатий
//        button.isEnabled = false
        
        // Анимация уменьшения кнопки и скрытия текста
        

            // Вычисляем конечный размер кружка загрузки
            

            // Показываем кружок загрузк
            
            // Анимация увеличения кружка загрузки до размера кнопки
//            UIView.animate(withDuration: 0.3) { [self] in
//                self.loaderView.transform = CGAffineTransform(scaleX: finalSize / self.loaderView.frame.size.width, y: finalSize / self.loaderView.frame.size.height)
//
//            } completion: { _ in
//                self.performSegue(withIdentifier: "goToMain", sender: nil)

                // По окончании анимации переходите на следующий экран
//                if self.userData() {
//                    self.performSegue(withIdentifier: "goToMain", sender: nil)
//                } else {
//                    self.allertNotify()
//                }
            //}
            
        






    
    

    @IBAction func unwindToMain(unwindSegue: UIStoryboardSegue) {
        navigationController?.popToRootViewController(animated: true)
    }

    
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        let hiddenKeyboardGesture = UITapGestureRecognizer(target: self,
                                                           action: #selector(kbWillBeHidden))
        scrollView.addGestureRecognizer(hiddenKeyboardGesture)
        APIManager.shared.fetchGroups { result in
            switch result {
            case .success(let groups):
                print(groups)
            case .failure(let error):
                print(error)
            }
        }
        
        APIManager.shared.fetchFriends { result in
            switch result {
            case .success(let friends):
                print(friends)
            case .failure(let failure):
                print(failure)
            }
        }
        
        APIManager.shared.fetchFotos { result in
            switch result {
            case .success(let fotos):
                print(fotos)
            case .failure(let error):
                print(error)
            }
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        clearData()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        // Подписываюсь на уведомления 
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    // MARK: - Actions
    // Создаю метод для размер клавиатуры при ее появлении
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo as! NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsents = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавил это на UIScrollView
        self.scrollView.contentInset = contentInsents
        scrollView.scrollIndicatorInsets = contentInsents
    }
    //Создаю метод при уходе клавиатуры чтобы ее размер был равен нулю
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsents = UIEdgeInsets.zero
        scrollView.contentInset = contentInsents
    }
     
    
    //Делаю метод , чтобы при клике на дисплей клавиатура уходила
    @objc func kbWillBeHidden() {
        self.scrollView.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "goToMain":
            if !userData() {
                allertNotify()
                return false
            } else {
                return true
            }
        default:
            return false
        }
    }
    
    // MARK: - Private methods
    
    //Добавляю UIAllertCont оповещание о неверном логине
    private func allertNotify() {
        let allertController = UIAlertController(
                   title: "Ошибка",
            message: "Некорректный логин или пароль",
            preferredStyle: .alert)
        
        let allertAction = UIAlertAction(title: "Отмена", style: .cancel)
        allertController.addAction(allertAction)
        present(allertController, animated: true)
    }
    
    // Создал метод где есть условие с верным логином
    private func userData() -> Bool {
        if loginTextField.text == "" && passwordTextField.text == "" {
            return true
        } else {
            return false
        }
        
    }
    
    private func clearData() {
        loginTextField.text = ""
        passwordTextField.text = ""
    }
    
       

    
 
}

