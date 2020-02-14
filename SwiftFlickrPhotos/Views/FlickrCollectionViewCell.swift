//
//  FlickrCollectionViewCell.swift
//  SwiftFlickrPhotos
//
//  Created by suraj poudel on 14/2/20.
//  Copyright © 2020 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

class FlickrCollectionViewCell:UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    
         var downloadTask: URLSessionDownloadTask?
    
         static let nibName = "FlickrCollectionViewCell"
         
         override func awakeFromNib() {
             super.awakeFromNib()
         }

         override func prepareForReuse() {
             imageView.image = nil
             downloadTask?.cancel()
             downloadTask = nil
         }
    
    var photoModel:FlickrPhoto?{
        didSet{
            if let photoModel = photoModel{
                imageView.image = UIImage(named:"placeholder")
                titleLabel.text = photoModel.title
                self.downloadTask = imageView.downloadImage(from: photoModel.imageURL)
            }
        }
    }
}
