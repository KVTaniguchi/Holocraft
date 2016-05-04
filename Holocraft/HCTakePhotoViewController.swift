//
//  HCTakePhotoViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/3/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit

class HCTakePhotoViewController: UIViewController {
    
    let backgroundPhotoImageView = UIImageView()
    let compositeImageView = UIImageView()
    let takePhotoImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenWidth = UIScreen.mainScreen().bounds.width
        
        for imageView in [backgroundPhotoImageView, compositeImageView, takePhotoImageView] {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
        }
        
        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        
        let metrics = ["imgW": screenWidth - 30]
        let views = ["back": backgroundPhotoImageView, "comp": compositeImageView, "take": takePhotoImageView, "guide": layoutGuide]
        layoutGuide.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[back][guide(20)][take]", options: [.AlignAllBottom, .AlignAllTop], metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("", options: [], metrics: metrics, views: views))
    }

}
