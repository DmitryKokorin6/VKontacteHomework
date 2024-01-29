//
//  APIManager.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 06.10.2023.
//

import Foundation
import RealmSwift

class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    func fetchFriends(completion: @escaping (Result<FriendsRequest, Error>) -> Void) {
        let path = "/method/friends.get"
        let queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "user_id", value: Session.instance.userId),
            URLQueryItem(name: "fields", value: "nickname"),
            URLQueryItem(name: "count", value: "300"),
            URLQueryItem(name: "order", value: "hints"),
            URLQueryItem(name: "v", value: "5.81")
        ]

        APIClient.shared.fetch(from: path, queryItems: queryItems) { (result: Result<FriendsRequest, Error>) in
            switch result {
            case .success(let friendsRequest):
                let friendsResponse = friendsRequest.response
                let responseInfoRealmArray = friendsResponse.items.map { friendInfo in
                    let infoRealm = FriendsResponseInfoRealm()
                    infoRealm.id = friendInfo.id
                    infoRealm.firstName = friendInfo.firstName
                    infoRealm.lastName = friendInfo.lastName
                    return infoRealm
                }
                // Сохраните responseInfoRealmArray в базу данных Realm
                self.save(objects: responseInfoRealmArray)
                completion(.success(friendsRequest))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func save<T: Object>(objects: [T]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(objects, update: .modified)
            }
        } catch {
            print(error)
        }
    }

    

    
    func fetchGroups(completion: @escaping (Result<GroupsRequest, Error>) -> Void) {
            let path = "/method/groups.get"
            let queryItems = [
                URLQueryItem(name: "access_token", value: Session.instance.token),
                URLQueryItem(name: "user_id", value: Session.instance.userId),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "v", value: "5.81")
            ]
            
        APIClient.shared.fetch(from: path, queryItems: queryItems) { (result: (Result<GroupsRequest, Error>)) in
            switch result {
            case .success(let groups):
                completion(.success(groups))
                let groupsResponse = groups.response
                let responseInfoRealmArray = groupsResponse.items.map { groupsInfo in
                    let groupsRealm = GroupsRequestNameRealm()
                    groupsRealm.name = groupsInfo.name
                    return groupsRealm
                }
                self.save(objects: responseInfoRealmArray)
                completion(.success(groups))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchFotos(completion: @escaping (Result<FotosRequest, Error>) -> Void) {
        let path = "/method/photos.get"
        let queryItems = [
            URLQueryItem(name: "album_id", value: "profile"),
            URLQueryItem(name: "v", value: "5.81"),
            URLQueryItem(name: "access_token", value: Session.instance.token)
        ]
        
        APIClient.shared.fetch(from: path, queryItems: queryItems) { (result: (Result<FotosRequest, Error>)) in
            switch result {
            case .success(let fotos):
                completion(.success(fotos))
                let fotosResponse = fotos.response
                let fotosResponseArray = fotosResponse.items.map { fotosInfo in
                    let fotosRealm = SizesUrlRealm()
                    fotosRealm.url = fotosInfo.sizes[0].url
                    return fotosRealm
                }
                self.save(objects: fotosResponseArray)
                completion(.success(fotos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSearchGroups(completion: @escaping ((Result<SearchGroupsRequest, Error>) -> Void)) {
        let path = "/method/groups.search"
        let queryItems = [
            URLQueryItem(name: "q", value: "GeekBrains"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.81")
        ]
        
        APIClient.shared.fetch(from: path, queryItems: queryItems) { (result: (Result<SearchGroupsRequest, Error>)) in
            switch result {
            case .success(let searchGroups):
                completion(.success(searchGroups))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
