//
//  APIClient.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 04.10.2023.
//

import Foundation
import RealmSwift

class APIClient {
    static let shared = APIClient()
    
    private let baseURL = "https://api.vk.com"
    
    func fetch<T: Decodable>(
        from path: String,
        queryItems: [URLQueryItem],
        complition: @escaping (Result<T, Error>) -> Void) {
            var urlComponents = URLComponents(string: baseURL)!
            urlComponents.path = path
            urlComponents.queryItems = queryItems
            
            guard
                let url = urlComponents.url
            else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    complition(.failure(error))
                    return
                }
                guard
                    let data = data
                else {
                    complition(.failure(NSError(domain: "Data is nil", code: -1, userInfo: nil)))
                    return
                }
                do {
                    let decodeData = try JSONDecoder().decode(T.self, from: data)
                    complition(.success(decodeData))
                } catch {
                    complition(.failure(error))
                }
            }.resume()
        }
    
    func save<T: Object>(objects: [T]) {
        do {
            let realm = try Realm()
            try realm.write{
                realm.add(objects, update: .modified)
            }
        } catch {
            print(error)
        }
    }

}


