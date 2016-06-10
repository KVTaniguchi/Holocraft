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

        title = "Buy"
    }
}
