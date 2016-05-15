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
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "View"
        
        if let allmedia = UIImagePickerController.availableMediaTypesForSourceType(.Camera) {
            imagePicker.mediaTypes = allmedia
        }
        
        view.backgroundColor = UIColor(red: 52/255, green: 52/255, blue: 119/255, alpha: 1.0)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        
        chooseImagesFromPhotoLibButton.setTitle("Choose Video", forState: .Normal)
        chooseImagesFromPhotoLibButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        chooseImagesFromPhotoLibButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        chooseImagesFromPhotoLibButton.backgroundColor = UIColor.darkGrayColor()
        
        let stackView = UIStackView(arrangedSubviews: [chooseImagesFromPhotoLibButton])
        stackView.alignment = .Fill
        stackView.distribution = .EqualCentering
        stackView.axis = .Vertical
        stackView.spacing = 50
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 0).active = true
        stackView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 0).active = true
        
        chooseImagesFromPhotoLibButton.addTarget(self, action: #selector(chooseImgButtonPressed), forControlEvents: .TouchUpInside)
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

