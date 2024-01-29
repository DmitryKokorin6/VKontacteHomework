//
//  TestTableViewController.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 25.07.2023.
//

import UIKit

class TestTableViewController: UITableViewController {
    
    @IBOutlet var searchBarTest: UISearchBar!
    
    var someUsers = [
        TestModel(name: "Кокорин Дмитрий"),
        TestModel(name: "Дмитрий"),
        TestModel(name: "Секси"),
        TestModel(name: "Качаться")
        
    ]
    
    var someUsersFilter: [TestModel] = []
    var sectionTitles: [String] = []
    var usersBySection: [String: [TestModel]] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        someUsers.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending}
        tableView.register(
            UINib(
                nibName: "TestTableViewCell",
                bundle: nil),
            forCellReuseIdentifier: "testTableViewCell")
        prepareForSection()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addUsers(_ segue: UIStoryboardSegue) {
        guard
            segue.identifier == "addUsers",
            let allUsersTableViewContro = segue.source as? TestAllTableViewController,
            let indexUser = allUsersTableViewContro.tableView.indexPathForSelectedRow
        else { return }
        self.someUsers.append(allUsersTableViewContro.someUsers[indexUser.section])
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if isFilteringTest {
            return 1
        }
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if isFilteringTest {
            return someUsers.count
        }
        
        let sectionTitle = sectionTitles[section]
        return usersBySection[sectionTitle]?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSomeUsers = someUsers[indexPath.row]
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "testTableViewCell", for: indexPath) as? TestTableViewCell
        else { return UITableViewCell() }
        
        if isFilteringTest {
            let someUsersFilter3 = someUsersFilter[indexPath.row]
            cell.configure(label: someUsersFilter3.name)
        }
        else {
            let sectionTitle = sectionTitles[indexPath.section]
            if let userBySections = usersBySection[sectionTitle] {
                let user = userBySections[indexPath.row]
                cell.configure(label: user.name)
            }
        }
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        performSegue(withIdentifier: "goToTestAll", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFilteringTest {
            return nil
        }
        return sectionTitles[section]
    }
    
    //MARK: - Actions
    
    private func prepareForSection() {
        var tempUsersBySection: [String: [TestModel]] = [:]
        
        for user in someUsers {
            let sectionTitle = String(user.name.prefix(1)).uppercased()
            if tempUsersBySection[sectionTitle] == nil {
                tempUsersBySection[sectionTitle] = []
            }
            tempUsersBySection[sectionTitle]?.append(user)
        }
        sectionTitles = tempUsersBySection.keys.sorted()
        usersBySection = tempUsersBySection
    }
    

}

extension TestTableViewController: UISearchBarDelegate {
    
    func prepareForSearch(_ searchText: String) {
        someUsersFilter = someUsers.filter { user in
            return user.name.lowercased().contains(searchText.lowercased())
            tableView.reloadData()
        }
    }
    
    var isFilteringTest: Bool {
        return !searchBarTest.text!.isEmpty
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        prepareForSearch(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        someUsersFilter.removeAll()
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
    

