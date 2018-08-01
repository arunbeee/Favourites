//
//  ViewController.swift
//  Favourites
//
//  Created by Arun Balakrishnan on 25/07/18.
//  Copyright © 2018 Arun Balakrishnan. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBAction func startAction(_ sender:Any){
        self.performSegue(withIdentifier: "startSegue", sender: nil)
    }

}

