//
//  SelectionViewController.swift
//  Favourites
//
//  Created by Arun Balakrishnan on 26/07/18.
//  Copyright © 2018 Arun Balakrishnan. All rights reserved.
//

import Foundation
import UIKit
class SelectionViewController:UIViewController {
    @IBOutlet weak var startBarButton:UIBarButtonItem!
    @IBOutlet weak var reviewBarButton:UIBarButtonItem!
    @IBOutlet weak var likeButton:UIButton!
    @IBOutlet weak var dislikeButton:UIButton!
    @IBOutlet weak var reviewedArticlesLabel:UILabel!
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    
    let selectionDataLoader = SelectionDataLoader()
    var currentArticleIndex = 0
    var label:UILabel {return UILabel(frame: reviewCollectionView.frame)}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewBarButton.isEnabled = false
        self.reviewedArticlesLabel.isHidden = true
        self.selectionDataLoader.loadArticles {[unowned self] (articles) in
            self.reviewCollectionView.reloadData()
            
            if (self.selectionDataLoader.articles.count) > 0 {
                self.reviewedArticlesLabel.isHidden = false
                self.reviewedArticlesLabel.text = "0/\(self.selectionDataLoader.articles.count)"
            }
        }
        
        //Add label
        
        label.center = reviewCollectionView.center
        label.text = "All articles are reviewed"
        label.textAlignment = .center
        self.reviewCollectionView.backgroundView = label
        label.isHidden = true
    }
    
    @IBAction func likeAction(_ sender:Any){
        self.selectionAction(isLiked: true)
    }
    
    @IBAction func disLikeAction(_ sender:Any){
       self.selectionAction(isLiked: false)

    }
    
    func selectionAction(isLiked:Bool){
        if let cell = self.reviewCollectionView.cellForItem(at: IndexPath(row: currentArticleIndex, section: 0)) as? SelectionCollectionViewCell{
            cell.liked(isLiked: isLiked, completed: {[unowned self] in
                let liked = isLiked ? ArticleState.liked : ArticleState.disLiked
                self.selectionDataLoader.setArticleSelection(index: self.currentArticleIndex, isLiked: liked)
                self.currentArticleIndex += 1
                self.loadArticle(at: self.currentArticleIndex)
                if self.currentArticleIndex > self.selectionDataLoader.articles.count - 1 {
                    self.likeButton.isEnabled = false
                    self.dislikeButton.isEnabled = false
                    self.reviewBarButton.isEnabled = true
                    self.label.isHidden = false
                    self.reviewCollectionView.isHidden = true
                }
                self.reviewedArticlesLabel.isHidden = false
                self.reviewedArticlesLabel.text = "\(self.selectionDataLoader.selectedCounter)/ \(self.selectionDataLoader.articles.count)"
            })
        }
    }
    
    @IBAction func startAction(_ sender:Any){
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func reviewAction(_ sender:Any){
        self.performSegue(withIdentifier: "toReview", sender: self)
    }
    
    func loadArticle(at index:Int){
        if index < self.selectionDataLoader.articles.count {
            self.reviewCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .top, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReview"{
            if let reviewController = segue.destination as? ReviewViewController {
                reviewController.selectionDataloader = self.selectionDataLoader
            }
        }

    }
}

extension SelectionViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectionDataLoader.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectionCollectionViewCell", for: indexPath)
        if let theCell = cell as? SelectionCollectionViewCell {
            theCell.imageView.image = self.selectionDataLoader.getDefaultImage()
            self.selectionDataLoader.loadImage(for: indexPath.row) { [unowned self](image) in
                if let theImage = image {
                    theCell.imageView.image = theImage
                } else {
                    theCell.imageView.image = self.selectionDataLoader.getDefaultImage()
                }
            }
        }
        return cell
    }
    
    
}
