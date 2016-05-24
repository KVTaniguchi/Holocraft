//
//  HCBuyViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/2/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit
import SafariServices

class HCBuyViewController: UIViewController {
    
    let link = "https://store.laserclassroom.com"
    let blurredBackground = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = NSURL(string: link) else { return }
        let safariView = SFSafariViewController(URL: url)
        addChildViewController(safariView)
        safariView.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(safariView.view)
        safariView.didMoveToParentViewController(self)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[sf]|", options: [], metrics: nil, views: ["sf": safariView.view]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[sf]|", options: [], metrics: nil, views: ["sf": safariView.view]))
        
//        blurredBackground.image = UIImage(named: "IMG_7430")
//        blurredBackground.translatesAutoresizingMaskIntoConstraints = false
//        blurredBackground.makeBlurImage()
//        view.addSubview(blurredBackground)
//        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))
//        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))

        title = "Buy"
//        view.backgroundColor = UIColor(red: 170/255, green: 121/255, blue: 57/255, alpha: 1.0)
    }
    
    
}
