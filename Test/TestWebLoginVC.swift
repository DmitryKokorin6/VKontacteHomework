////
////  TestWebLoginVC.swift
////  VkApp
////
////  Created by Дмитрий Кокорин on 26.10.2023.
////
//
//import Foundation
//import RealmSwift
//import Realm
//
//class TestFriendsRequestRealm: Object {
//
//    @Persisted var response: TestFriendsResponseCountRealm?
//}
//
//
//
//class TestFriendsResponseCountRealm: Object {
//
//    @Persisted var count: Int
//
//    @Persisted var items = List<TestFriendsResponseInfoRealm>()
//}
//
//class TestFriendsResponseInfoRealm: Object {
//
//    @Persisted var id: Int = 0
//
//    @Persisted var firstName: String = ""
//
//    @Persisted var lastName: String = ""
//
//    override static func primaryKey() -> String? {
//        return "id"
//    }
//    enum CodingKeys: String, CodingKey {
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case id
//    }
//}
//
//
//class TestView: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadDate()
//
//    }
//
//    func loadDate() {
//        var urlComponents = URLComponents(string: "https://api.vk.com/method/friends.get")
//        urlComponents?.queryItems = [
//            URLQueryItem(name: "user_id", value: Session.instance.userId),
//            URLQueryItem(name: "fields", value: "nickname"),
//            URLQueryItem(name: "count", value: "300"),
//            URLQueryItem(name: "order", value: "hints"),
//            URLQueryItem(name: "access_token", value: Session.instance.token),
//            URLQueryItem(name: "v", value: "5.81"),
//        ]
//        guard let url = urlComponents?.url else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                do {
//                    let post = try JSONDecoder().decode(FriendsRequest.self, from: data)
//                    let realmPosts = TestFriendsRequestRealm()
//                    let responseCountRealm = TestFriendsResponseCountRealm()
//                    responseCountRealm.count = post.response.count
//
//                    // Преобразование FriendsResponseInfo в FriendsResponseInfoRealm
//                    let responseInfoRealmArray = post.response.items.map { friendInfo in
//                        let infoRealm = FriendsResponseInfoRealm()
//                        infoRealm.id = friendInfo.id
//                        infoRealm.firstName = friendInfo.firstName
//                        infoRealm.lastName = friendInfo.lastName
//                        return infoRealm
//                    }
//
//                    responseCountRealm.items.append(objectsIn: responseInfoRealmArray)
//                    realmPosts.response = responseCountRealm
//                    self.save(posts: realmPosts)
//                    print(post)
//                } catch {
//                    print(error)
//                }
//            }
//        }
//    }
//
//
//    private func save(posts: TestFriendsRequestRealm) {
//        do {
//            let realm = try Realm()
//            try realm.write {
//                realm.add(posts)
//            }
//        } catch {
//            print(error)
//        }
//    }
//}
