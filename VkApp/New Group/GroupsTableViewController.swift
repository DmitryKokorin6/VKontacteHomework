
//
//  GroupsTableViewController.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 12.06.2023.
//

import UIKit
import RealmSwift

class GroupsTableViewController: UITableViewController {
    
    var groups = [Group]() {
        didSet {
//            tableView.reloadData()
        }
    }
    
        // Метод для добавления группы в список и обновления таблицы
//        func addGroup(group: Group) {
//            // Проверяем, что группы еще нет в списке, чтобы избежать повторного добавления
//            if !self.groups.contains(group) {
//                // Добавляем группу в список
//                self.groups.append(group)
//                // Сохраняем изменения и обновляем таблицу
//            }
//        }

        // ... (остальной код класса)
    var groupsResponse: [GroupsRequestName] = []

    var groupsFromRealm: Results<GroupsRequestNameRealm>?
    var notificationToken: NotificationToken?

    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard
            // делаю проверку
            segue.identifier == "addGroup",
            // обращаюсь ко всем группам и кастю
            let allGroupController = segue.source as? AllGroupsTableViewController,
                        // нужен индекс нажатой ячейки
            let groupIndexPath = allGroupController.tableView.indexPathForSelectedRow,
            // чтобы не было повторений
            !self.groups.contains(allGroupController.group[groupIndexPath.section])
        else { return }
        self.groups.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        self.groups.append(allGroupController.group[groupIndexPath.section])
        tableView.reloadData()
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "GroupTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "groupCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        APIManager.shared.fetchGroups { [weak self] result in
            switch result {
            case .success(let groups):
                self?.handleRequestGroups(groups)
                self?.loadGroupsFromRealm()
            case .failure(let error):
                print(error)
            }
            
        }
        
        loadGroupsFromRealm()
    }


    func updateUIAfterDeletion(at indexPath: IndexPath) {
        // Убеждаемся, что groupsFromRealm не nil и индекс находится в пределах массива
        guard let groupsFromRealm = groupsFromRealm, indexPath.row < groupsFromRealm.count else {
            return
        }

        do {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(groupsFromRealm[indexPath.row])
            }

            // Обновляем массив friendsFromRealm
            loadGroupsFromRealm()
        } catch {
            print("Error deleting friend from Realm: \(error)")
        }
    }

    func loadGroupsFromRealm() {
        DispatchQueue.main.async { [weak self] in
            do {
                let realm = try Realm()
                self?.groupsFromRealm = realm.objects(GroupsRequestNameRealm.self)
                
                if let groupsFromRealm = self?.groupsFromRealm {
                    print("Loaded \(groupsFromRealm.count) groups from Realm")
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    if let strongSelf = self {
                        strongSelf.setupNotificationToken(for: groupsFromRealm)
                    }
                } else {
                    print("Groups from Realm is nil")
                }
                
                
                // Выполняем операции Realm на основном потоке
            } catch {
                print("Error loading friends from Realm: \(error)")
            }
        }
    }
    func setupNotificationToken(for results: Results<GroupsRequestNameRealm>) {
            self.notificationToken = results.observe { [weak self] changes in
                switch changes {
                case .initial:
                    print("Initial change")
                    self?.tableView.beginUpdates()
                    self?.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    print("Update change")
                    self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    self?.tableView.endUpdates()
                    
                case .error(let error):
                    // Обработка ошибок
                    print("Error: \(error)")
                }
            }
        }
    //MARK: - Actions
    func handleRequestGroups(_ groupsResponse: GroupsRequest) {
        self.groupsResponse = groupsResponse.response.items
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        groupsFromRealm?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupTableViewCell else { return UITableViewCell() }

            guard let groupsResponse = self.groupsFromRealm?[indexPath.row] else { return UITableViewCell() }
            cell.configure(groups: groupsResponse)

        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        super.tableView(tableView, didSelectRowAt: indexPath)
        defer { tableView.deselectRow(at: indexPath, animated: true) }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Получаем группу из Realm
            guard let groupsToDelete = self.groupsFromRealm?[indexPath.row] else { return }
            
            // Удаляем группу из Realm
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(groupsToDelete)
                }
                loadGroupsFromRealm()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
            } catch {
                print("Error deleting group from Realm: \(error)")
            }
//            setupNotificationToken(for: groupsFromRealm!)
            // Убеждаемся, что обновление интерфейса выполняется на основном потоке
            tableView.reloadData()
            updateUIAfterDeletion(at: indexPath)
        }
    }

    

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

}

