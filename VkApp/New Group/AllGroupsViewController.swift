//
//  AllGroupsTableViewController.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 12.06.2023.
//

import UIKit

class AllGroupsTableViewController: UITableViewController {
    
    @IBOutlet var tableViewAllGroup: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var group = [
        Group(avatar: UIImage(named: "Паспорт Кокорин") ?? UIImage(), name: "Группа набора мышц"),
        Group(avatar: UIImage(named: "Паспорт Кокорин") ?? UIImage(), name: "Ученые"),
        Group(avatar: UIImage(named: "Паспорт Кокорин") ?? UIImage(), name: "Самурай")
    ]
    
    var groupFiler: [Group] = []
    var sectionTitles: [String] = []
    var groupBySection: [String: [Group]] = [:]
    
    var searchGroupsResponse: [SearchGroupsName] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        group.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        tableView.register(UINib(nibName: "GroupTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "groupCell")
//        prepareForDataSection()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        APIManager.shared.fetchSearchGroups { result in
            switch result {
            case .success(let searchGroups):
                self.handleSearchGroupsResponse(searchGroups)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    //MARK: - Actions
    func handleSearchGroupsResponse(_ searchGroupsRequest: SearchGroupsRequest) {
        self.searchGroupsResponse = searchGroupsRequest.response.items
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        if isFiltering {
//            return 1
//        }
//
//        return sectionTitles.count
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if isFiltering {
//            return groupFiler.count
//        }
//
//        let sectionTitle = sectionTitles[section]
//        return groupBySection[sectionTitle]?.count ?? 0
        searchGroupsResponse.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchGroupsRequest = searchGroupsResponse[indexPath.row]
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupTableViewCell
        else { return UITableViewCell() }
        
//        if isFiltering {
//            let group = groupFiler[indexPath.row]
//            cell.configureForAll(imageGroup: group.avatar, name: group.name)
//        } else {
//            let sectionTitle = sectionTitles[indexPath.section]
//            if let groupInSection = groupBySection[sectionTitle], indexPath.row < groupInSection.count {
//                let group = groupInSection[indexPath.row]
//                cell.configureForAll(imageGroup: group.avatar, name: group.name)
//            }
//        }
        cell.configureForAll(searchGroups: searchGroupsRequest)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        performSegue(withIdentifier: "addGroup", sender: nil)
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        if isFiltering {
//            return nil
//        }
//        return sectionTitles[section]
//    }
    private func prepareForDataSection() {
        var tempGroupBySection: [String: [Group]] = [:]
        
        for someGroup in group {
            let firstLetter = String(someGroup.name.prefix(1)).uppercased()
            if tempGroupBySection[firstLetter] == nil {
                tempGroupBySection[firstLetter] = []
            }
            tempGroupBySection[firstLetter]?.append(someGroup)
        }
        sectionTitles = tempGroupBySection.keys.sorted()
        groupBySection = tempGroupBySection
    }
}
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        print("Preparing for segue: \(segue.identifier ?? "")")
    //
    //        if segue.identifier == "addGroup", let groupIndexPath = tableViewAllGroup.indexPathForSelectedRow {
    //            // Получаем выбранную группу
    //            let selectedGroup = group[groupIndexPath.row]
    //
    //            // Получаем экземпляр GroupsTableViewController
    //            if let destinationVC = segue.destination as? GroupsTableViewController {
    //                // Вызываем метод добавления группы, передав выбранную группу
    //                destinationVC.addGroup(group: selectedGroup)
    //                print("Segue preparation successful.")
    //            } else {
    //                print("Destination VC not found or not of type GroupsTableViewController.")
    //            }
    //        } else {
    //            print("Segue with identifier 'addGroup' not found or incorrect identifier.")
    //        }
    //    }
    
    extension AllGroupsTableViewController: UISearchBarDelegate {

        // MARK: - Search
        private func filterGroupSearch(_ searchText: String) {
            groupFiler = group.filter({ someGroup in
                return someGroup.name.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        }

        var isFiltering: Bool {
            return !searchBar.text!.isEmpty
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filterGroupSearch(searchText)
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            groupFiler.removeAll()
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


