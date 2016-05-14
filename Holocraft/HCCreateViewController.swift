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
import CameraEngine

class HCCreateViewController: UIViewController {
    
    let takeVideoButton = UIButton(type: .Custom)
    let viewVideoButton = UIButton(type: .Custom)
    let defaults = NSUserDefaults.standardUserDefaults()
    let videoImageView = UIImageView()
    let key = "com.Holocraft.videos"
    let takeVideoVC = HCTakePhotoViewController()
    var videoURL = NSURL()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Create"
        view.backgroundColor = UIColor.redColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(save))
        
        videoImageView.contentMode = .ScaleAspectFit
        videoImageView.layer.borderColor = UIColor.whiteColor().CGColor
        videoImageView.layer.borderWidth = 1.0
        takeVideoButton.setTitle(NSLocalizedString("Create Video", comment: ""), forState: .Normal)
        viewVideoButton.setTitle(NSLocalizedString("View Video", comment: ""), forState: .Normal)
        takeVideoButton.addTarget(self, action: #selector(takeVideoBtnPressed), forControlEvents: .TouchUpInside)
        viewVideoButton.addTarget(self, action: #selector(showVideo), forControlEvents: .TouchUpInside)
        
        for button in [takeVideoButton, viewVideoButton] {
            button.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
            button.setTitleColor(view.tintColor, forState: .Normal)
        }
        
        let views = ["take": takeVideoButton, "view": viewVideoButton, "video": videoImageView]
        for subView in [takeVideoButton, viewVideoButton, videoImageView] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }

        videoImageView.heightAnchor.constraintEqualToConstant(UIScreen.mainScreen().bounds.width).active = true
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[take][view(take)]|", options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[video]-15-[take(44)]-44-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[video]|", options: [], metrics: nil, views: views))
        
        takeVideoVC.videoCaptured = { vidURL in
            guard let url = vidURL else { return }
            self.videoURL = url
            let asset = AVURLAsset(URL: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            do {
                let cgImg = try generator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
                let image = UIImage(CGImage: cgImg)
                self.videoImageView.image = image
            }
            catch {
                print("Warning: failed to fetch image from video err \(error) asdfasd")
            }
        }

    }
    
    func save() {
        if var videoURLS = defaults.arrayForKey(key) {
            videoURLS.append(videoURL.absoluteString)
            defaults.setValue(videoURLS, forKey: key)
        }
        
        CameraEngineFileManager.saveVideo(videoURL) { (success, error) -> (Void) in
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
