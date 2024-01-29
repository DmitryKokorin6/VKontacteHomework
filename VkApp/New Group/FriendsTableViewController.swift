//
//  FriendsTableViewController.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 12.06.2023.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UITableViewController {
    //СОздал модель
    var friends = [
        User(avatar: UIImage(named: "Паспорт Кокорин") ?? UIImage(), name: "Дмитрий"),
        User(avatar: UIImage(named: "Паспорт Кокорин") ?? UIImage(), name: "Анна"),
        User(avatar: UIImage(named: "Паспорт Кокорин") ?? UIImage(), name: "Кокорин Дима"),
        User(avatar: UIImage(named: "Паспорт Кокорин") ?? UIImage(), name: "Пися")
    ]
    
    var filterFriends: [User] = []
    var sectionTitles: [String] = []
    var friendsBySections: [String: [User]] = [:]
    
    
    
    var searchBar: UISearchBar!
    var searchBarView: UIView!
    var textField: UITextField!
    
    var friendsResponse: [FriendsResponseInfo] = [] // Массив для хранения списка друзей
    
    var friendsFromRealm: Results<FriendsResponseInfoRealm>?
    var notificationToken: NotificationToken?

    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friends.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        tableView.register(UINib(nibName: "FriendsCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "friendsCell")
        
        searchBarView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 50))
        searchBarView.backgroundColor = .white
        
        textField = UITextField(frame: CGRect(x: 20, y: 10, width: tableView.frame.width - 40, height: 30))
        textField.textColor = .black
        textField.tintColor = .orange
        textField.borderStyle = .roundedRect
        textField.placeholder = "Найти"
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        searchBarView.addSubview(textField)
        tableView.tableHeaderView = searchBarView
        
        let kbClear = UITapGestureRecognizer(target: self, action: #selector(kbWillClear))
        kbClear.cancelsTouchesInView = false
        tableView.addGestureRecognizer(kbClear)
        prepareDataForSections()
            
            // Вызываем функцию fetchFriends из APIManager для загрузки списка друзей
            APIManager.shared.fetchFriends { [weak self] result in
                switch result {
                case .success(let friends):
                    // Обработка успешной загрузки списка друзей
                    self?.handleFriendsRequest(friends) // Функция, которая обновляет UI с учетом загруженных друзей
                case .failure(let error):
                    // Обработка ошибки при загрузке
                    print("Failed to load friends: \(error)")
                }
            }
        loadFriendsFromRealm()
        // ...

        notificationToken = friendsFromRealm?.observe { [weak self] changes in
                // Выполняйте все операции Realm на главном потоке
                do {
                    switch changes {
                    case .initial:
                        self?.tableView.reloadData()
                    case .update(_, let deletions, let insertions, let modifications):
                        self?.tableView.beginUpdates()
                        self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                        self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                        self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                        self?.tableView.endUpdates()
                    case .error(let error):
                        // Обработка ошибок
                        print("Error: \(error)")
                    }
                } catch {
                    print(error)
                    
                }
            }
    

        // ...

    }

    func updateUIAfterDeletion(at indexPath: IndexPath) {
        guard let friendsFromRealm = friendsFromRealm, indexPath.row < friendsFromRealm.count else {
            return
        }

        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(friendsFromRealm[indexPath.row])
            }

            
                loadFriendsFromRealm()
                tableView.deleteRows(at: [indexPath], with: .fade)
            
        } catch {
            print("Ошибка удаления друга из Realm: \(error)")
        }
    }


    func loadFriendsFromRealm() {
            do {
                let realm = try Realm()
                friendsFromRealm = realm.objects(FriendsResponseInfoRealm.self)
                
                    tableView.reloadData()
                }
             catch {
                print("Ошибка загрузки друзей из Realm: \(error)")
            }
        }
    


    func handleDeletion(at index: Int) {
        print("Уведомление: Ячейка удалена в Realm по индексу \(index)")
        tableView.reloadData()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    //MARK: - Actions
    
    @objc
    func kbWillClear() {
        textField.resignFirstResponder()
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        filterContentForSearchText(textField.text ?? "")
    }
    
    func handleFriendsRequest(_ friendsRequest: FriendsRequest) {
        self.friendsResponse = friendsRequest.response.items // Сохраняем список друзей из запроса
        tableView.reloadData() // Обновляем таблицу, чтобы отобразить новых друзей
    }

    // MARK: - Table view data source
    // число секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // если фильтрация возвращаестя лишь секция
//        if isFiltering {
//            return 1
//        }
//        return sectionTitles.count
        1
    }
    // число строк
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //чтобы произвести пересчет нужно массив, он может содержать классы структуры моделей но это массив
        //теперь нет зависимости от константы захардкддд по numberOfRows

        
//        if isFiltering {
//            return filterFriends.count
//        }
//
//        let sectionTitle = sectionTitles[section]
//        return friendsBySections[sectionTitle]?.count ?? 0
//
        return friendsFromRealm?.count ?? 0
    }
    
    // метод позволяет сформировать ячейку из пула ячеейк UITableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  индекс который мне нужно сконфигурировать
//        let currentFriend = friends[indexPath.row]
        
//        let currentFilterFriend: User
        
        // делаю приведение типов через guard else
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as? FriendsCell
        else { return UITableViewCell() }
        
//        if isFiltering {
//            let friend = filterFriends[indexPath.row]
//            cell.configure(friends: friend.avatar, name: friend.name)
//        } else {
//
//            let sectionTitle = sectionTitles[indexPath.section]
//            if let friendsInSection = friendsBySections[sectionTitle], indexPath.row < friendsInSection.count {
//                let friend = friendsInSection[indexPath.row]
//                cell.configure(friends: friend.avatar, name: friend.name)
//            }
//        }
        
//
//        cell.configure(friends: currentFilterFriend.avatar,
//                       name: currentFilterFriend.name)
        
//        cell.animateAction = { [weak self, weak cell] in
//            guard let cell = cell else { return }
//            self?.performAnimation(for: cell)
//        }
        guard let friendsResponse = friendsFromRealm?[indexPath.row] else { return UITableViewCell() }
        cell.configure(friend: friendsResponse)
        
        cell.animateAction = { [weak self, weak cell] in
            guard
                let cell = cell
            else { return }
            self?.performAnimation(for: cell)
            
        }
        return cell
    }
    
    func performAnimation(for cell: FriendsCell) {
           UIView.animate(withDuration: 0.5, animations: {
               let rotationTransform = CGAffineTransform(rotationAngle: .pi)
               let scaleTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
               
               let combinedTransform = rotationTransform.concatenating(scaleTransform)
               cell.transform = combinedTransform
               cell.alpha = 0.5
           }) { _ in
               UIView.animate(withDuration: 0.5) {
                   cell.transform = .identity
                   cell.alpha = 1.0
               }
           }
       }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        performSegue(withIdentifier: "goToInfo", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Получаем друга из Realm и удаляем
            DispatchQueue.main.async {
                guard let friendToDelete = self.friendsFromRealm?[indexPath.row] else { return }
                
                // Обновляем массив friendsFromRealm
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.delete(friendToDelete)
                    }
                } catch {
                    print("Error deleting friend from Realm: \(error)")
                }
                
                // Обновляем массив friendsFromRealm после удаления
                self.loadFriendsFromRealm()
                
                // Обновляем интерфейс
                self.tableView.reloadData()
            }
        }
    }




//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if isFiltering {
//            return nil
//        }
//        return sectionTitles[section]
//    }
//
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        if isFiltering {
//            return nil
//        }
//        return sectionTitles
//    }
    
    func prepareDataForSections() {
        var tempFriendsBySection: [String: [User]] = [:]
        
        for friend in friends {
            let firstLetter = String(friend.name.prefix(1)).uppercased()
            if tempFriendsBySection[firstLetter] == nil {
                tempFriendsBySection[firstLetter] = []
            }
            tempFriendsBySection[firstLetter]?.append(friend)
        }
        sectionTitles = tempFriendsBySection.keys.sorted()
        friendsBySections = tempFriendsBySection
    }
}

extension FriendsTableViewController: UISearchBarDelegate, UITextFieldDelegate {
    // филььтрация при различных регистрах ьольшие маленикие
    func filterContentForSearchText(_ searchText: String) {
        filterFriends = friends.filter { friend in
            return friend.name.lowercased().contains(searchText.lowercased()) }
//        prepareDataForSections()
        tableView.reloadData()
    }
    // если фильтрация проиходиь значит true и поисковая строка заполнена
    // когда false все должно оьоьражаиься и сьрока пустая
    var isFiltering: Bool {
        return !textField.text!.isEmpty
    }
    // когда происходит ввод текста вызываеься эьа функция коьорая про регисьр
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterFriends.removeAll()
//        prepareDataForSections()
        tableView.reloadData()
    }
}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



