//
//  SelectionCollectionViewCell.swift
//  Favourites
//
//  Created by Arun Balakrishnan on 01/08/18.
//  Copyright © 2018 Arun Balakrishnan. All rights reserved.
//

import UIKit

class SelectionCollectionViewCell:UICollectionViewCell{
    @IBOutlet weak var imageView:UIImageView!
    let tickTag = 100
    func liked(isLiked:Bool, completed:@escaping ()->Void){
        let imageView = UIImageView(frame: CGRect(x: self.center.x, y: self.center.y, width: 100, height: 100))
        imageView.tag = tickTag
        if isLiked {
            imageView.image = UIImage(named: "like")
        } else {
            imageView.image = UIImage(named: "unlike")
        }
        self.addSubview(imageView)
        let rect = CGRect(x: self.bounds.size.width - 40 - 8, y: 20, width: 40, height: 40)
        UIView.animate(withDuration: 0.6, animations: { 
            imageView.frame = rect
        }) { (done) in
            imageView.frame = rect
            completed()
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for view in self.subviews {
            if view.tag == tickTag {
                view.removeFromSuperview()
            }
        }
    }
}
