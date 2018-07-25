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
    @IBOutlet weak var articleImageView:UIImageView!
    
    let selectionDataLoader = SelectionDataLoader()
    var currentArticleIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewBarButton.isEnabled = false
        self.reviewedArticlesLabel.isHidden = true
        self.articleImageView.image = self.selectionDataLoader.getDefaultImage()
        self.selectionDataLoader.loadArticles {[weak self] (articles) in
            self?.loadArticle(at: self?.currentArticleIndex ?? 0)
            if (self?.selectionDataLoader.articles.count)! > 0 {
                self?.reviewedArticlesLabel.isHidden = false
                self?.reviewedArticlesLabel.text = "\(self?.selectionDataLoader.selectedCounter)/ \(self?.selectionDataLoader.articles.count)"
            }
        }
    }
    
    @IBAction func likeAction(_ sender:Any){
        self.selectionDataLoader.setArticleSelection(index: currentArticleIndex, isLiked: .liked)
        currentArticleIndex += 1
        loadArticle(at: currentArticleIndex)
        if currentArticleIndex > self.selectionDataLoader.articles.count - 1 {
            likeButton.isEnabled = false
            dislikeButton.isEnabled = false
            self.reviewBarButton.isEnabled = true
        }
        self.reviewedArticlesLabel.isHidden = false

        self.reviewedArticlesLabel.text = "\(self.selectionDataLoader.selectedCounter)/ \(self.selectionDataLoader.articles.count)"
    }
    
    @IBAction func disLikeAction(_ sender:Any){
        self.selectionDataLoader.setArticleSelection(index: currentArticleIndex, isLiked: .disLiked)
        currentArticleIndex += 1
        loadArticle(at: currentArticleIndex)
        if currentArticleIndex > self.selectionDataLoader.articles.count - 1 {
            likeButton.isEnabled = false
            dislikeButton.isEnabled = false
            self.reviewBarButton.isEnabled = true
        }
        self.reviewedArticlesLabel.isHidden = false
        self.reviewedArticlesLabel.text = "\(self.selectionDataLoader.selectedCounter)/ \(self.selectionDataLoader.articles.count)"

    }
    
    @IBAction func startAction(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reviewAction(_ sender:Any){
        self.performSegue(withIdentifier: "toReview", sender: self)
    }
    
    func loadArticle(at index:Int){
        self.selectionDataLoader.loadImage(for: index) {[weak self] (image) in
            if let theImage = image {
                self?.articleImageView.image = theImage
            } else {
                self?.articleImageView.image = self?.selectionDataLoader.getDefaultImage()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReview"{
            if let reviewController = segue.destination as? ReviewViewController {
                reviewController.selectionDataloader = self.selectionDataLoader
            }
        }

    }
    
    deinit {
        print("Deallocation SelectionVC")
    }
}
