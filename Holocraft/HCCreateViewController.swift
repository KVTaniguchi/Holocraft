//
//  HCCreateViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/2/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class HCCreateViewController: UIViewController {
    
    let takeVideoButton = UIButton(type: .Custom)
    let viewVideoButton = UIButton(type: .Custom)
    
    let videoView = UIView()
    
    let takeVideoVC = HCTakePhotoViewController()
    var videoURL = NSURL()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Create"
        view.backgroundColor = UIColor.redColor()
        
        takeVideoButton.setTitle(NSLocalizedString("Create Video", comment: ""), forState: .Normal)
        viewVideoButton.setTitle(NSLocalizedString("View Video", comment: ""), forState: .Normal)
        takeVideoButton.addTarget(self, action: #selector(takeVideoBtnPressed), forControlEvents: .TouchUpInside)
        viewVideoButton.addTarget(self, action: #selector(showVideo), forControlEvents: .TouchUpInside)
        
        for button in [takeVideoButton, viewVideoButton] {
            button.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
            button.setTitleColor(view.tintColor, forState: .Normal)
        }
        
        let views = ["take": takeVideoButton, "view": viewVideoButton, "video": videoView]
        for subView in views.values {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        let offSet = (navigationController?.navigationBar.frame.height)! + UIApplication.sharedApplication().statusBarFrame.height
        let metrics = ["offSet": offSet]
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[take][view(take)]|", options: [.AlignAllTop, .AlignAllBottom], metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-offSet-[take][video]|", options: [], metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[video]|", options: [], metrics: nil, views: views))
        
        takeVideoVC.videoCaptured = { vidURL in
            guard let url = vidURL else { return }
            self.videoURL = url
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        viewVideoButton.enabled = !HCFaceFramesManager.shared.hcFaceObjects.isEmpty
    }
    
    func showVideo() {
        let previewVC = HCVideoPreviewerVC(videoURL: self.videoURL)
        presentViewController(previewVC, animated: true, completion: nil)
    }
    
    func takeVideoBtnPressed() {
        presentViewController(takeVideoVC, animated: true, completion: nil)
    }

}
