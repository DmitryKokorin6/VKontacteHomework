//
//  NewsViewController.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 06.08.2023.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet var tableViewNews: UITableView!
    
    var news: [News] = [
        News(user: "Кокорин", userImageView: "Паспорт Кокорин", text: "Качаеься когда ьо", imageViewNews: "Паспорт Кокорин", likes: 0, isLike: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewNews.register(
            UINib(
                nibName: "NewsTableViewCell",
                bundle: nil),
            forCellReuseIdentifier: "newsTableViewCell")
        
        tableViewNews.register(
            UINib(
                nibName: "HeaderNewsTableViewCell",
                bundle: nil),
            forCellReuseIdentifier: "headerNewsTableViewCell")
        
        tableViewNews.register(
            UINib(
                nibName: "FooterNewsTableViewCell",
                bundle: nil),
            forCellReuseIdentifier: "footerNewsTableViewCell")
        // Do any additional setup after loading the view.
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return news.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentNews = news[indexPath.row]
        
        
        if indexPath.section == 0 {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerNewsTableViewCell", for: indexPath) as? HeaderNewsTableViewCell
            else { return UITableViewCell() }
            
            cell.userImageView.image = UIImage(named: currentNews.userImageView)
            cell.userNameLabel.text = currentNews.user
            
            return cell
        } else if indexPath.section == 1 {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableViewCell", for: indexPath) as? NewsTableViewCell
            else { return  UITableViewCell() }
            
            cell.userTextLabel.text = currentNews.text
            cell.userNewsImageView.image = UIImage(named: currentNews.imageViewNews)
            
            return cell
        } else {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "footerNewsTableViewCell", for: indexPath) as? FooterNewsTableViewCell
            else { return UITableViewCell() }
            
            cell.userLikeButton.addTarget(self, action: #selector(likeButtonPress), for: .touchUpInside)
            cell.userLikeButton.tag = indexPath.row
            
            
            
            return cell
        }

        

    }
    
    @objc
    private func likeButtonPress(_ sender: UIButton) {
        let index = sender.tag
        news[index].isLike.toggle()
        let likeState = UIImage(systemName: news[index].isLike ? "heart" : "heart.fill")
        
        sender.setImage(likeState, for: .normal)
        
        let likeCount = news[index].isLike ? "" : "1"
        sender.setTitle(likeCount, for: .normal)
    }

}
