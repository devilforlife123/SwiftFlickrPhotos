//
//  Extensions.swift
//  SwiftFlickrPhotos
//
//  Created by suraj poudel on 14/2/20.
//  Copyright © 2020 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func register(nib nibName: String) {
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
  func downloadImage(from imgURL: String) -> URLSessionDownloadTask? {
    
    var task:URLSessionDownloadTask? = nil
    
      guard let url = URL(string: imgURL) else { return nil }

      if let imageToCache = imageCache.object(forKey: imgURL as NSString) {
        GCD.runOnMainThread {
            self.image = imageToCache
        }
        return nil
      }
    
    GCD.runAsync {
        task = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            if let err = error {
                print(err)
                return
            }
            GCD.runOnMainThread {
                if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data){
                    imageCache.setObject(image, forKey: imgURL as NSString)
                    self.image = image
                }
            }

        }
        
        task?.resume()
    }

    
    return task
     
  }
}
