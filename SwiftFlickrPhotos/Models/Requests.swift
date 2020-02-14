//
//  Requests.swift
//  SwiftFlickrPhotos
//
//  Created by suraj poudel on 14/2/20.
//  Copyright © 2020 suraj poudel. All rights reserved.
//

import Foundation

enum RequestMethod:String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    
    var value:String{
        return self.rawValue
    }
}

class Request:NSMutableURLRequest{
    
    convenience init?(requestMethod: RequestMethod, urlString: URL, bodyParams: [String: Any]? = nil){
        
        self.init(url: urlString)
        
        do {
            if let bodyParams = bodyParams {
                let data = try JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
                self.httpBody = data
            }
        } catch {
            
        }
        
        self.httpMethod = requestMethod.value
        
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
    }
}
