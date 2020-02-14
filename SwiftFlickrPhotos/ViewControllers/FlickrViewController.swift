//
//  FlickrViewController.swift
//  SwiftFlickrPhotos
//
//  Created by suraj poudel on 14/2/20.
//  Copyright © 2020 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

class FlickrCollectionViewController:UIViewController{
    
       @IBOutlet weak var searchBar: UISearchBar!
       @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
       @IBOutlet weak var collectionView: UICollectionView!
    
       var viewModel = FlickrViewModel()
       let numberOfColumns: CGFloat = 3
    
        override func viewDidLoad() {
            super.viewDidLoad()
            configureUI()
            viewModelClosures()
        }
    
        func configureUI(){
        
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .automatic
            collectionView.register(nib: FlickrCollectionViewCell.nibName)
        }
    
        func viewModelClosures(){
           viewModel.showAlert = { [weak self]
                          (message) in
                        GCD.runOnMainThread {
                            self?.showAlert(message: message)
                        }
            }
                      
            viewModel.dataUpdated = {
                          [weak self] in
                        GCD.runOnMainThread {
                            self?.collectionView.reloadData()
                        }
            }
        }
    
        func showAlert(title: String = "Flickr", message: String?) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title:NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {(action) in
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
}

extension FlickrCollectionViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
        self.searchBar.isHidden = true
        self.activityIndicator.startAnimating()
        guard let text = searchBar.text,text.count > 1 else{
            return
        }
        GCD.runAsync { [weak self] in
            self?.viewModel.search(text: text) {
                GCD.runOnMainThread {
                    self?.searchBar.isHidden = false
                    self?.activityIndicator.stopAnimating()
                    print("Search Completed")
                }
            }
        }
        
        
    }
}

extension FlickrCollectionViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrCollectionViewCell.nibName, for: indexPath) as! FlickrCollectionViewCell
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return viewModel.photoArray.count
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? FlickrCollectionViewCell else{
            return
        }
        
        let photoModel = viewModel.photoArray[indexPath.row]
        cell.photoModel = photoModel
        
        if (indexPath.row == (viewModel.photoArray.count - 10)){
            loadNextPage()
        }
        
        
    }
    
    private func loadNextPage(){
        GCD.runAsync { [weak self] in
            self?.viewModel.fetchNextPage {
                       print("next page fetched")
        
            }
        }
    }
}
extension FlickrCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width)/numberOfColumns, height: (collectionView.bounds.width)/numberOfColumns)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
