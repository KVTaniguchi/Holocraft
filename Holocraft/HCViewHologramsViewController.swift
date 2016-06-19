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
        
        blurredBackground.image = UIImage(named: "IMG_7430")
        blurredBackground.translatesAutoresizingMaskIntoConstraints = false
        blurredBackground.makeBlurImage()
        view.addSubview(blurredBackground)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))
        
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        chooseImagesFromPhotoLibButton.setTitle("Choose Gif", forState: .Normal)
        chooseImagesFromPhotoLibButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        chooseImagesFromPhotoLibButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        chooseImagesFromPhotoLibButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)
        chooseImagesFromPhotoLibButton.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
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
        
        guard let url = info[UIImagePickerControllerReferenceURL] as? NSURL else { return }
        guard let imageAsset = PHAsset.fetchAssetsWithALAssetURLs([url], options: nil).firstObject as? PHAsset else { return }
        
        PHImageManager.defaultManager().requestImageDataForAsset(imageAsset, options: nil) { (data, dataUTI, orientation, info) in
            guard let imgData = data else { return }
            
            picker.dismissViewControllerAnimated(true) {
                let playerController = HCHologramPlayerViewController(data: imgData)
                self.presentViewController(playerController, animated: true, completion: nil)
            }
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

