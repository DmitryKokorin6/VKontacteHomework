//
//  TestView.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 14.07.2023.
//

import UIKit

final class FriendsCollectionView: UIViewController {
    
    @IBOutlet var friendsCollectionView: UICollectionView!
    
    
    var photos: [UIImage?] = [
            UIImage(systemName: "heart"),
            UIImage(systemName: "star"),
            UIImage(named: "Паспорт Кокорин")
    
    ] // Здесь храните фотографии из вашей коллекции
    
    var fotosResponse: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async {
                self.friendsCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendsCollectionView.register(UINib(
            nibName: "FriendsCollectionViewCell",
            bundle: nil),
            forCellWithReuseIdentifier: "friendsCollectionViewCell")
        
        APIManager.shared.fetchFotos { result in
            switch result {
            case .success(let fotos):
                self.handleResponseFoto(fotoResponse: fotos)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func handleResponseFoto(fotoResponse: FotosRequest) {
        for item in fotoResponse.response.items {
            if let url = item.sizes.last?.url,
               let imageURL = URL(string: url)  {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                guard let image = UIImage(data: imageData) else { return }
                fotosResponse.append(image)
            }
        }
        DispatchQueue.main.async {
            self.friendsCollectionView.reloadData()
        }
    }
}

extension FriendsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let imageResponse = fotosResponse[indexPath.item]
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsCollectionViewCell", for: indexPath) as? FriendsCollectionViewCell
        else { return UICollectionViewCell() }
        
        
//        cell.friendsImageView.image = UIImage(systemName: image.imageView)
//        cell.likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
//        cell.likeButton.tag = indexPath.item
        cell.config(friendsImage: imageResponse)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fotosResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToFullScreen", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFullScreen", let indexPath = sender as? IndexPath {
            if let fullImageViewController = segue.destination as? FullImageViewController {
                fullImageViewController.photos = fotosResponse
                fullImageViewController.currentIndex = indexPath.item
            }
        }
    }
    
//    @objc
//    private func likeButtonPressed(_ sender: UIButton) {
//        let index = sender.tag
//        photos[index].isLike.toggle()
//
//        let likeState = UIImage(systemName: photos[index].isLike ? "heart" : "heart.fill")
//        sender.setImage(likeState, for: .normal)
//
//        let likeCount = photos[index].isLike ? "" : "1"
//        sender.setTitle(likeCount, for: .normal)
//
//    }
    
}



    

