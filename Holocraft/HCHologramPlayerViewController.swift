//
//  HCHologramPlayerViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/14/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit
import Gifu

class HCHologramPlayerViewController: UIViewController {
    
    private var image: UIImage?
    
    private var leftView = AnimatableImageView()
    private var rightView = AnimatableImageView()
    private var topView = AnimatableImageView()
    private var bottomView = AnimatableImageView()
    
    let closeButton = UIButton()
    
    convenience init(data: NSData) {
        self.init()
        
        leftView.animateWithImageData(data)
        rightView.animateWithImageData(data)
        topView.animateWithImageData(data)
        bottomView.animateWithImageData(data)
        
        leftView.rotate(angle: -90)
        rightView.rotate(angle: 90)
//        bottomView.setInputRotation(kGPUImageRotateRight, atIndex: 0)
        bottomView.rotate(angle: 180)
//        topView.setInputRotation(kGPUImageRotateRight, atIndex: 0)
        
//        rightView.rotate(angle: 180)
//        bottomView.setInputRotation(kGPUImageRotateRight, atIndex: 0)
//        bottomView.rotate(angle: 180)
//        topView.setInputRotation(kGPUImageRotateRight, atIndex: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blackColor()
        
        for btn in [closeButton] {
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setTitleColor(view.tintColor, forState: .Normal)
            btn.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
            view.addSubview(btn)
        }
        
        closeButton.setTitle("Close", forState: .Normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), forControlEvents: .TouchUpInside)
        closeButton.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant:  20).active = true
        closeButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -20).active = true
        
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
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[left(70)][guide(150)][right(70)]", options: [.AlignAllCenterY], metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[top(imgH)][guide(130)][bot(imgH)]", options: [.AlignAllCenterX], metrics: metrics, views: views))
        
        for view in [leftView, rightView] {
            view.heightAnchor.constraintEqualToConstant(100).active = true
        }
        for view in [topView, bottomView] {
            view.widthAnchor.constraintEqualToConstant(70).active = true
        }
    }
    
    func closeButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension UIView {
    func rotate(angle angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat(M_PI)
        let rotation = CGAffineTransformRotate(self.transform, radians);
        self.transform = rotation
    }
    
}
