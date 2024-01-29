//
//  GroupTableViewCell.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 25.06.2023.
//

import UIKit

final class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet var imageGroup: GroupImage!
    @IBOutlet var nameGroup: UILabel!
    
    func configure(groups: GroupsRequestNameRealm) {
        self.imageGroup.image = UIImage(named: "Паспорт Кокорин")
        self.nameGroup.text = "\(groups.name) "
    }
    
    func configureForAll(searchGroups: SearchGroupsName) {
        self.imageGroup.image = UIImage(named: "Паспорт Кокорин")
        self.nameGroup.text = "\(searchGroups.name)"
    }
}
