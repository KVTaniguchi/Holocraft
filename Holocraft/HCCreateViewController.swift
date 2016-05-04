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
        
        let views = ["take": takePhotoButton, "choose": choosePhotoButton]
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[take][choose(take)]|", options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: views))
        takePhotoButton.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
    }

}
