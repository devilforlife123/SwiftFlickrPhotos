//
//  NetworkManager.swift
//  SwiftFlickrPhotos
//
//  Created by suraj poudel on 14/2/20.
//  Copyright © 2020 suraj poudel. All rights reserved.
//

import Foundation

enum Result<T>{
    case Success(T)
    case Failure(String)
    case Error(String)
}

class NetworkManager:NSObject{
    
    static let shared = NetworkManager()
    static let errorMessage = "Something went wrong,please try again later"
    static let noInternetConnection = "Please check your Internet connection and try again."
    
    func fetchJSON<T>(urlString:URL,resource:Resource<T>,completion:@escaping (Result<T?>)->()){
        
        
        guard (Reachability.currentReachabilityStatus != .notReachable)else{
           return
            completion(.Failure(NetworkManager.noInternetConnection))
        }
        
        let request = Request.init(requestMethod: .get, urlString: urlString)
        URLSession.shared.dataTask(with: request! as URLRequest ) { (data, response, error) in
            if error != nil{
                completion(.Error(NetworkManager.errorMessage))
            }
            if let data = data {
                completion(.Success(resource.parse(data)))
            }else{
                completion(.Failure(NetworkManager.errorMessage))
            }
            
        }.resume()
    }
}
