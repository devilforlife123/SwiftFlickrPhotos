//
//  FlickrConstants.swift
//  SwiftFlickrPhotos
//
//  Created by suraj poudel on 14/2/20.
//  Copyright © 2020 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

struct FlickrConstants{
    
    static let api_key = "96358825614a5d3b1a1c3fd87fca2b47"
       static let per_page = 60
    static let searchURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(FlickrConstants.api_key)&format=json&nojsoncallback=1&safe_search=1&per_page=\(FlickrConstants.per_page)&text=%@&page=%ld"
     static let imageURL = "https://farm%d.staticflickr.com/%@/%@_%@_\(FlickrConstants.size.url_s.value).jpg"
    
    enum size: String {
        case url_sq = "s"
        case url_q = "q"
        case url_t = "t"    //thumbnail, 100 on longest side
        case url_s = "m"    //small, 240 on longest side
        case url_n = "n"    //small, 320 on longest side
        case url_m = "-"    //medium, 500 on longest side
        case url_z = "z"    //medium 640, 640 on longest side
        case url_c = "c"    //medium 800, 800 on longest side†
        case url_l = "b"    //large, 1024 on longest side*
        case url_h = "h"    //large 1600, 1600 on longest side†
        case url_k = "k"    //large 2048, 2048 on longest side†
        case url_o = "o"    //original image, either a jpg, gif or
        var value: String {
            return self.rawValue
        }
    }
    
    static let defaultColumnCount: CGFloat = 3.0
}
