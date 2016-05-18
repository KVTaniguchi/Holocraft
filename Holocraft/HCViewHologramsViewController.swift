//
//  HCViewHologramsViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/2/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CameraEngine
import Photos

class HCViewHologramsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let chooseImagesFromPhotoLibButton = UIButton()
    let instructionalLabel = UILabel()
    let blurredBackground = UIImageView()
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "View"
        
        if let allmedia = UIImagePickerController.availableMediaTypesForSourceType(.Camera) {
            imagePicker.mediaTypes = allmedia
        }
        
        blurredBackground.image = UIImage(named: "IMG_0685")
        blurredBackground.translatesAutoresizingMaskIntoConstraints = false
        blurredBackground.makeBlurImage()
        view.addSubview(blurredBackground)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))
        
        view.backgroundColor = UIColor(red: 52/255, green: 52/255, blue: 119/255, alpha: 1.0)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        chooseImagesFromPhotoLibButton.setTitle("Choose Video", forState: .Normal)
        chooseImagesFromPhotoLibButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        chooseImagesFromPhotoLibButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        chooseImagesFromPhotoLibButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)
        chooseImagesFromPhotoLibButton.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        chooseImagesFromPhotoLibButton.layer.cornerRadius = 2
        chooseImagesFromPhotoLibButton.addTarget(self, action: #selector(chooseImgButtonPressed), forControlEvents: .TouchUpInside)
        
        chooseImagesFromPhotoLibButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chooseImagesFromPhotoLibButton)
        
        chooseImagesFromPhotoLibButton.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        chooseImagesFromPhotoLibButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        chooseImagesFromPhotoLibButton.widthAnchor.constraintEqualToConstant(200).active = true
        chooseImagesFromPhotoLibButton.heightAnchor.constraintEqualToConstant(60).active = true

    }
    
    func chooseImgButtonPressed() {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let player: HCHologramPlayerViewController
        
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String else {
            picker.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if mediaType == "public.movie" {
            guard let movieURL = info[UIImagePickerControllerReferenceURL] as? NSURL else { return }
            player = HCHologramPlayerViewController(movie: movieURL)
        }
        else {
            let imageKeys = Set([UIImagePickerControllerEditedImage, UIImagePickerControllerOriginalImage, UIImagePickerControllerCropRect, UIImagePickerControllerMediaMetadata])
            let allKeysSet = Set(info.keys)
            let intersect = imageKeys.intersect(allKeysSet)
            
            guard let imageKey = intersect.first, image = info[imageKey] as? UIImage else { return }
            // process the image for hologram
            player = HCHologramPlayerViewController(img: image)
        }
        
        picker.dismissViewControllerAnimated(true) {
            self.presentViewController(player, animated: true, completion: nil)
        }
    }
}

extension UIImageView{
    
    func makeBlurImage() {
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
    }
    
}

