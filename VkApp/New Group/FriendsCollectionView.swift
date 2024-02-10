//
//  TestView.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 14.07.2023.
//

import UIKit
import Realm
import RealmSwift

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
    
    var fotosResponseRealm: Results<FotosRequestRealm>?
    var notificationToken: NotificationToken?
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
                self.loadFotosFromRealm()
                self.setupNotificationToken()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func handleResponseFoto(fotoResponse: FotosRequest) {
        DispatchQueue.global().async {
            do {
                let realm = try Realm()
                try realm.write {
                    for item in fotoResponse.response.items {
                        if let url = item.sizes.last?.url,
                           let imageURL = URL(string: url),
                           let imageData = try? Data(contentsOf: imageURL),
                           let image = UIImage(data: imageData) {
                            // Check if object with the same URL already exists
                            if realm.object(ofType: SizesUrlRealm.self, forPrimaryKey: url) == nil {
                                let sizesUrlRealm = SizesUrlRealm()
                                sizesUrlRealm.url = url
                                realm.add(sizesUrlRealm)
                            }
                        }
                    }
                }
            } catch {
                print("Error writing to Realm: \(error)")
            }
        }
    }

    
    func loadFotosFromRealm() {
        DispatchQueue.main.async { // Убедимся, что операции с Realm происходят в главном потоке
            do {
                let realm = try Realm()
                self.fotosResponseRealm = realm.objects(FotosRequestRealm.self)
                
                if let fotos = self.fotosResponseRealm {
                    // Convert Results<FotosRequestRealm> to an array of UIImage
                    self.fotosResponse = fotos.compactMap { foto in
                        guard let sizes = foto.response?.items.first?.sizes,
                              let url = sizes.last?.url,
                              let imageURL = URL(string: url),
                              let imageData = try? Data(contentsOf: imageURL),
                              let image = UIImage(data: imageData) else {
                            return nil
                        }
                        return image
                    }
                } else {
                    print("fotosResponseRealm is nil after querying Realm")
                }
                
                self.friendsCollectionView.reloadData()
            } catch {
                print("Error loading fotos from Realm: \(error)")
            }
        }
    }



    func setupNotificationToken() {
        DispatchQueue.main.async { // Убедимся, что установка наблюдателя происходит в главном потоке
            do {
                let realm = try Realm()
                self.notificationToken = self.fotosResponseRealm?.observe { [weak self] changes in
                    switch changes {
                    case .initial:
                        print("Initial data loaded from Realm")
                        self?.loadFotosFromRealm()
                    case .update(_, _, _, _):
                        print("Realm data updated")
                        self?.loadFotosFromRealm()
                    case .error(let error):
                        print("Error observing Realm changes: \(error)")
                    }
                }
            } catch {
                print("Error setting up notification token: \(error)")
            }
        }
    }

}

extension FriendsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            indexPath.item < fotosResponse.count
        else {
            return UICollectionViewCell()
        }
        
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



    

