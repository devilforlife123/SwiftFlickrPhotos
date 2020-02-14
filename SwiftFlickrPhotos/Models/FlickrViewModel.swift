//
//  FlickrViewModel.swift
//  SwiftFlickrPhotos
//
//  Created by suraj poudel on 14/2/20.
//  Copyright © 2020 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

struct Resource<T>{
    let url:URL
    let parse:(Data)->T?
}

class FlickrViewModel:NSObject{
    
     private(set) var photoArray = [FlickrPhoto]()
     private var searchText = ""
     private var pageNo = 1
     private var totalPageNo = 1
     var showAlert:((String)->())?
     var dataUpdated:(()->())?
    
     func search(text:String,completion:@escaping()->()){
        searchText = text
        photoArray.removeAll()
        fetchResults(completion: completion)
    }
    
    func fetchResults(completion:@escaping()->()){
        
        let searchingText = searchText.components(separatedBy: CharacterSet.whitespacesAndNewlines).compactMap({$0}).joined()
        let urlString = String(format: FlickrConstants.searchURL, searchingText,pageNo)
        if let urlString = URL(string: urlString){
            
            let resource = Resource<Photos>(url: urlString) { (data) -> Photos? in
                       let responseModel = try? JSONDecoder().decode(FlickrSearchResults.self, from: data)
                if let responseModel = responseModel{
                    if responseModel.stat == "ok"{
                       return responseModel.photos
                    }else{
                       return nil
                    }
                }else{
                    return nil
                }
            }
            
        NetworkManager.shared.fetchJSON(urlString:urlString,resource: resource) {[weak self] (result) in
                switch result{
                        case .Success(let results):
                           if let result = results {
                            self?.totalPageNo = result.pages
                            self?.photoArray.append(contentsOf: result.photo)
                            self?.dataUpdated?()
                           }else{
                            self?.showAlert?("Parsing Error")
                           }
                           completion()
                       case .Failure(let message):
                        self?.showAlert?(message)
                               completion()
                       case .Error(let error):
                        if self!.pageNo > 1 {
                                self?.showAlert?(error)
                               }
                            completion()
                       }
        }
        }
    }
        
     func fetchNextPage(completion:@escaping ()->()){
          if pageNo < totalPageNo{
              pageNo += 1
              fetchResults {
                  completion()
              }
          }else{
              completion()
          }
      }
        
        
        
}

