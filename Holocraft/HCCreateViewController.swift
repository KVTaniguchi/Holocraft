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
    let defaults = NSUserDefaults.standardUserDefaults()
    let videoImageView = UIImageView()
    let key = "com.Holocraft.videos"
    let takeVideoVC = HCTakePhotoViewController()
    var videoURL = NSURL()
    
    let imageController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageController.sourceType = .Camera
        if let allmedia = UIImagePickerController.availableMediaTypesForSourceType(.Camera) {
            imageController.mediaTypes = allmedia
        }
        imageController.allowsEditing = true
        imageController.delegate = self

        title = "Create"
        view.backgroundColor = UIColor.redColor()
        
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
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info)
        
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String else {
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if mediaType == "public.movie" {
            guard let movieURL = info[UIImagePickerControllerMediaURL] as? NSURL else { return }
            videoURL = movieURL
            print(movieURL)
            CameraEngineFileManager.saveVideo(movieURL, blockCompletion: { (success, error) -> (Void) in
                let asset = AVURLAsset(URL: movieURL)
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
        
        viewVideoButton.enabled = !HCFaceFramesManager.shared.hcFaceObjects.isEmpty
    }
    
    func showVideo() {
        let player = HCHologramPlayerViewController(movie: videoURL)
        presentViewController(player, animated: true, completion: nil)
    }
    
    func takeVideoBtnPressed() {
        presentViewController(imageController, animated: true, completion: nil)
    }

}
