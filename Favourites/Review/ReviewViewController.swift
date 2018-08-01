//
//  ReviewViewController.swift
//  Favourites
//
//  Created by Arun Balakrishnan on 26/07/18.
//  Copyright © 2018 Arun Balakrishnan. All rights reserved.
//

import Foundation
import UIKit

class ReviewViewController:UIViewController{
    var displayMode:Mode = .list
    @IBOutlet weak var reviewCollectionView:UICollectionView!
    @IBOutlet weak var cancelBarButton:UIBarButtonItem!
    @IBOutlet weak var gridBarButton:UIBarButtonItem!
    
    var selectionDataloader:SelectionDataLoader?
    var selectedArticles = [Article]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let theDataloader = self.selectionDataloader {
            let theArticles = theDataloader.articles.filter({$0.isLiked == .liked})
            selectedArticles.append(contentsOf: theArticles)
        }
    }
    
    @IBAction func cancelAction(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeLayoutAction(_ sender:Any){
        let gridImage = UIImage(named: "grid")
        let listImage = UIImage(named: "list")
        let layout = reviewCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        switch self.displayMode{
        case .list:
            layout?.itemSize = CGSize(width: 150, height: 150)
            self.displayMode = .grid
            self.gridBarButton.image = listImage
    
        case .grid:
            layout?.itemSize = CGSize(width: reviewCollectionView.frame.size.width - 20, height: 100)
            self.displayMode = .list
            self.gridBarButton.image = gridImage
        }
        if let theLayout = layout {
            reviewCollectionView.setCollectionViewLayout(theLayout, animated: true)
        }
        
        reviewCollectionView.reloadData()
    }
    
}
extension ReviewViewController:UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedArticles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier = ""
        switch self.displayMode {
        case .grid:
            identifier = "ReviewShortCell"
        case .list:
            identifier = "ReviewLongCell"
    
        }
        let article = self.selectedArticles[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let theCell = cell as? ReviewLongCell {
           theCell.articleLabel.text = article.title
            if let theImageURL = article.cachedImageURL{
                theCell.articleImageView.image = UIImage(named: theImageURL)
            }
        }else if let theCell = cell as? ReviewShortCell{
            if let theImageURL = article.cachedImageURL{
                theCell.articleImageView.image = UIImage(named: theImageURL)
            }
        }
        return cell
    }
    
    
}

enum Mode{
    case grid
    case list
}
