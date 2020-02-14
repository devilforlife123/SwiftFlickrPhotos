//
//  FlickrSearchResults.swift
//  SwiftFlickrPhotos
//
//  Created by suraj poudel on 14/2/20.
//  Copyright © 2020 suraj poudel. All rights reserved.
//

import Foundation

class FlickrSearchResults:Codable{
    
    let stat:String?
    let photos:Photos?
    
    enum CodingKeys: String, CodingKey {
         case stat
         case photos
     }
     
     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         stat = try container.decodeIfPresent(String.self, forKey: .stat)
         photos = try container.decodeIfPresent(Photos.self, forKey: .photos)
     }
}
