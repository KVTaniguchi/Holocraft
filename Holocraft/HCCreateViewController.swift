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

class HCCreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let takeVideoButton = UIButton(type: .Custom)
    let viewVideoButton = UIButton(type: .Custom)
    let videoImageView = UIImageView()
    
    let blurredBackground = UIImageView()
    
    var videoURL = NSURL()
    
    let imageController = UIImagePickerController()
    
    let splashBackingView = HCCreateSplashView()
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurredBackground.image = UIImage(named: "IMG_0667")
        blurredBackground.translatesAutoresizingMaskIntoConstraints = false
        blurredBackground.makeBlurImage()
        view.addSubview(blurredBackground)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))
        
        imageController.sourceType = .Camera
        if let allmedia = UIImagePickerController.availableMediaTypesForSourceType(.Camera) {
            imageController.mediaTypes = allmedia
        }
        imageController.allowsEditing = true
        imageController.delegate = self
        
        splashBackingView.startCreatingNowButton.addTarget(self, action: #selector(takeVideoBtnPressed), forControlEvents: .TouchUpInside)

        title = "Create"
        view.backgroundColor = UIColor(red: 170/255, green: 142/255, blue: 57/255, alpha: 1.0)
        
        videoImageView.contentMode = .ScaleAspectFit
        takeVideoButton.setTitle(NSLocalizedString("Create Video", comment: ""), forState: .Normal)
        viewVideoButton.setTitle(NSLocalizedString("View Video", comment: ""), forState: .Normal)
        takeVideoButton.backgroundColor = UIColor(white: 1.0, alpha: 0.6)
        takeVideoButton.addTarget(self, action: #selector(takeVideoBtnPressed), forControlEvents: .TouchUpInside)
        viewVideoButton.addTarget(self, action: #selector(showVideo), forControlEvents: .TouchUpInside)
        viewVideoButton.backgroundColor = UIColor(white: 1.0, alpha: 0.6)
        
        for button in [takeVideoButton, viewVideoButton] {
            button.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
            button.setTitleColor(view.tintColor, forState: .Normal)
            button.backgroundColor = UIColor.redColor()
        }
        
        splashBackingView.backgroundColor = UIColor.whiteColor()
        splashBackingView.layer.cornerRadius = 2
        
        let views = ["splash": splashBackingView, "take": takeVideoButton, "view": viewVideoButton]
        
        for subView in views.values {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[splash]-30-|", options: [], metrics: nil, views: views))
        splashBackingView.heightAnchor.constraintEqualToConstant(300).active = true
        splashBackingView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String else {
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if mediaType == "public.movie" {
            guard let movieURL = info[UIImagePickerControllerMediaURL] as? NSURL else { return }
            videoURL = movieURL
            CameraEngineFileManager.saveVideo(movieURL, blockCompletion: { (success, error) -> (Void) in
                let asset = AVURLAsset(URL: movieURL)
                let generator = AVAssetImageGenerator(asset: asset)
                generator.appliesPreferredTrackTransform = true
                do {
                    let cgImg = try generator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
                    let image = UIImage(CGImage: cgImg)
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.videoImageView.image = image
                    })
                }
                catch {
                    print("Warning: failed to fetch image from video err \(error) asdfasd")
                }
            })
        }
        else {
            if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                CameraEngineFileManager.savePhoto(editedImage, blockCompletion: { (success, error) -> (Void) in
                    self.videoImageView.image = editedImage
                })
                return
            }
            if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                CameraEngineFileManager.savePhoto(originalImage, blockCompletion: { (success, error) -> (Void) in
                    self.videoImageView.image = originalImage
                })
                return
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        viewVideoButton.enabled = !videoURL.absoluteString.isEmpty
    }
    
    func showVideo() {
        let player = HCHologramPlayerViewController(movie: videoURL)
        presentViewController(player, animated: true, completion: nil)
    }
    
    func takeVideoBtnPressed() {
        presentViewController(imageController, animated: true, completion: nil)
    }

}

class HCCreateSplashView: UIView {
    let createYourOwnLabel = UILabel()
    let createDetailText = UILabel()
    let showMeHowButton = UIButton()
    let startCreatingNowButton = UIButton()
    let dontShowThisAgainButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createYourOwnLabel.text = NSLocalizedString("Create your own Hologram", comment: "")
        createDetailText.text = NSLocalizedString("Learn how to create your own hologram or get started right away with creating a new hologram", comment: "")
        showMeHowButton.setTitle(NSLocalizedString("Show me how", comment: ""), forState: .Normal)
        startCreatingNowButton.setTitle(NSLocalizedString("Start creating now", comment: ""), forState: .Normal)
        dontShowThisAgainButton.setTitle(NSLocalizedString("Don't show this again", comment: ""), forState: .Normal)
        
        createYourOwnLabel.textColor = UIColor.blueColor()
        createYourOwnLabel.font = UIFont(name: "Avenir", size: 20)
        createDetailText.textColor = UIColor.darkGrayColor()
        createDetailText.font = UIFont(name: "Avenir", size: 14)
        
        for label in [createDetailText, createYourOwnLabel] {
            label.textAlignment = .Center
            label.lineBreakMode = .ByWordWrapping
            label.numberOfLines = 0
        }
        
        let views = ["createYourOwn": createYourOwnLabel, "createDetail": createDetailText, "show": showMeHowButton, "startNow": startCreatingNowButton, "dontShow": dontShowThisAgainButton]
        
        for subView in views.values {
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        for subView in [createDetailText, createYourOwnLabel, showMeHowButton, startCreatingNowButton, dontShowThisAgainButton] {
            addSubview(subView)
        }
        
        for button in [showMeHowButton, startCreatingNowButton] {
            button.backgroundColor = UIColor.blueColor()
            button.layer.cornerRadius = 5
            button.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        }
        
        dontShowThisAgainButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[createYourOwn(50)]-[createDetail]-20-[show(44)]-10-[startNow(show)]-20-[dontShow(20)]-|", options: [.AlignAllCenterX], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[createYourOwn]-20-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[createDetail]-20-|", options: [], metrics: nil, views: views))
        showMeHowButton.widthAnchor.constraintEqualToConstant(200).active = true
        startCreatingNowButton.widthAnchor.constraintEqualToConstant(200).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
