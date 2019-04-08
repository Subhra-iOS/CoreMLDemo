//
//  ViewController.swift
//  CoreMLVisionDemo
//
//  Created by Subhra Roy on 07/04/19.
//  Copyright © 2019 Subhra Roy. All rights reserved.
// defaults write com.apple.finder AppleShowAllFiles TRUE

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDesLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapOnMedia(_ sender: Any) {
        let actionSheetAlertController : UIAlertController = UIAlertController(title: "Alert", message: "Please select your source.", preferredStyle: .actionSheet)
        let cameraAction : UIAlertAction = UIAlertAction(title: "Camera", style: .cancel) { (action) in
            
        }
    }
    

}

