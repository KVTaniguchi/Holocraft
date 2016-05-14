//
//  HCHologramPlayerViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/14/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit

class HCHologramPlayerViewController: UIViewController {
    
    private var image: UIImage?
    private var movieURL: NSURL?
    
    let leftView = UIView()
    let rightView = UIView()
    let topView = UIView()
    let bottomView = UIView()
    let centerView = UIView()
    
    let closeButton = UIButton()
    
    convenience init(img: UIImage) {
        self.init()
        
        image = img
    }
    
    convenience init(movie: NSURL) {
        self.init()
        
        movieURL = movie
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.setTitle("Close", forState: .Normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), forControlEvents: .TouchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        closeButton.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        closeButton.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 40).active = true
        closeButton.hidden = true
        
        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        let views = ["left": leftView, "right": rightView, "top": topView, "bot": bottomView, "guide": layoutGuide]
        
        let horizontalGuideWidth = UIScreen.mainScreen().bounds.width - 200
        let verticalConstant = horizontalGuideWidth
        let metrics = ["imgH": 100, "vertPadding": verticalConstant]
        
        for videoView in [leftView, rightView, topView, bottomView] {
            videoView.backgroundColor = UIColor.orangeColor()
            videoView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(videoView)
        }
        
        layoutGuide.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 0).active = true
        layoutGuide.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 0).active = true
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[left(imgH)][guide][right(imgH)]|", options: [.AlignAllCenterY], metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[top(imgH)][guide(vertPadding)][bot(imgH)]", options: [.AlignAllCenterX], metrics: metrics, views: views))
        
        for view in [leftView, rightView] {
            view.heightAnchor.constraintEqualToConstant(60).active = true
        }
        for view in [topView, bottomView] {
            view.widthAnchor.constraintEqualToConstant(60).active = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        closeButton.hidden = false
    }
    
    func closeButtonPressed() {
        closeButton.hidden = true
        dismissViewControllerAnimated(true, completion: nil)
    }

}
