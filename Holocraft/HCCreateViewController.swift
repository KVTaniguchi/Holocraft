//
//  HCCreateViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/2/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit

class HCCreateViewController: UIViewController {
    
    let takePhotoButton = UIButton(type: .Custom)
    let choosePhotoButton = UIButton(type: .Custom)
    
    let backgroundPhotoImageView = UIImageView()
    let compositeImageView = UIImageView()
    let takePhotoImageView = UIImageView()
    
    let takePhotoVC = HCTakePhotoViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Create"
        view.backgroundColor = UIColor.redColor()
        
        takePhotoButton.setTitle(NSLocalizedString("Take Photo", comment: ""), forState: .Normal)
        choosePhotoButton.setTitle(NSLocalizedString("Choose Photo", comment: ""), forState: .Normal)
        
        for btn in [takePhotoButton, choosePhotoButton] {
            btn.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(btn)
        }
        
        let views = ["take": takePhotoButton, "choose": choosePhotoButton, "back": backgroundPhotoImageView, "comp": compositeImageView, "takePhoto": takePhotoImageView]
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[take][choose(take)]|", options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: views))
        takePhotoButton.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        
        takePhotoButton.addTarget(self, action: #selector(takePhotoBtnPressed), forControlEvents: .TouchUpInside)
        
        for imageView in [backgroundPhotoImageView, compositeImageView, takePhotoImageView] {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
        }
        
        backgroundPhotoImageView.image = UIImage(named: "photoStack")
        takePhotoImageView.image = UIImage(named: "camera")
        compositeImageView.image = UIImage(named: "editImage")
        
        compositeImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[back(100)][comp(100)][takePhoto(100)]", options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[back(100)]-100-|", options: [], metrics: nil, views: views))
        
    }
    
    func takePhotoBtnPressed() {
        
        presentViewController(takePhotoVC, animated: true, completion: nil)
        takePhotoVC.takePictureButton.addTarget(self, action: #selector(picBtnPressed), forControlEvents: .TouchUpInside)
    }
    
    func picBtnPressed() {
//        takePhotoVC.gpuVideoCamera
    }

}
