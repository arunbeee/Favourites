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
    @IBOutlet weak var reviewCollectionView:UICollectionView!
    @IBOutlet weak var cancelBarButton:UIBarButtonItem!
    @IBOutlet weak var listBarButton:UIBarButtonItem!
    @IBOutlet weak var gridBarButton:UIBarButtonItem!
    
    var selectionDataloader:SelectionDataLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.selectionDataloader?.articles.filter({$0.isLiked == .liked}).count)
    }
    
    @IBAction func cancelAction(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("Deallocation ReviewVC")
    }
}
