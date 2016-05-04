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

        let screenWidth: CGFloat = 100
        
        for imageView in [backgroundPhotoImageView, compositeImageView, takePhotoImageView] {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
        }
        
        backgroundPhotoImageView.image = UIImage(named: "photoStack")
        takePhotoImageView.image = UIImage(named: "camera")
        compositeImageView.image = UIImage(named: "editImage")
        
        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        
        let metrics = ["imgW": screenWidth - 30]
        let views = ["back": backgroundPhotoImageView, "comp": compositeImageView, "take": takePhotoImageView, "guide": layoutGuide]
        layoutGuide.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        layoutGuide.heightAnchor.constraintEqualToConstant(screenWidth)
        layoutGuide.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 40)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[back(imgW)][guide(10)][take(imgW)]", options: [.AlignAllBottom, .AlignAllTop], metrics: metrics, views: views))
//        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("", options: [], metrics: metrics, views: views))
        compositeImageView.topAnchor.constraintEqualToAnchor(layoutGuide.bottomAnchor, constant: 30).active = true
        compositeImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 0).active = true
        compositeImageView.widthAnchor.constraintEqualToConstant(screenWidth).active = true
        compositeImageView.heightAnchor.constraintEqualToConstant(screenWidth).active = true
    }

}
