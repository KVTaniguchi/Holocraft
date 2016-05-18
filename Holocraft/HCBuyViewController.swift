//
//  HCBuyViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/2/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit

class HCBuyViewController: UIViewController {
    
    let blurredBackground = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurredBackground.image = UIImage(named: "IMG_7430")
        blurredBackground.translatesAutoresizingMaskIntoConstraints = false
        blurredBackground.makeBlurImage()
        view.addSubview(blurredBackground)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))

        title = "Buy"
        view.backgroundColor = UIColor(red: 170/255, green: 121/255, blue: 57/255, alpha: 1.0)
    }
}
