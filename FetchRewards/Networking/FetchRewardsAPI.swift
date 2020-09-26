//
//  FetchRewardsAPI.swift
//  FetchRewards
//
//  Created by Eric Figura on 9/26/20.
//  Copyright © 2020 FetchRewards. All rights reserved.
//

import Foundation

protocol APIInterface {
     func get<T: Codable>(router: Router, completion: @escaping (Result<[T], Error>) -> ())
}

struct FetchRewardsAPI: APIInterface {
    private init() {}
    
    static let shared = FetchRewardsAPI()
    
    
    func get<T: Codable>(router: Router, completion: @escaping (Result<[T], Error>) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.host = router.baseUrl
        urlComponents.path = router.path
        urlComponents.scheme = router.scheme
        
        guard let url = urlComponents.url else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Put the UI updates on the main thread. 
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }
                
                guard let data = data, response != nil else {
                    completion(.failure(NSError(domain: "Missing Data", code: 0, userInfo: nil)))
                    return
                }
                
                if let result = try? JSONDecoder().decode([T].self, from: data) {
                    completion(.success(result))
                }
                else {
                    completion(.failure(NSError(domain: "Cannot decode data", code: 0, userInfo: nil)))
                }
            }
            
            
        }.resume()
    }
}
