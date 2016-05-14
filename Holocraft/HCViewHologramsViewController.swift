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
import CameraManager
import Photos

class HCViewHologramsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let chooseImagesFromPhotoLibButton = UIButton()
    let playHologramButton = UIButton()
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let allmedia = UIImagePickerController.availableMediaTypesForSourceType(.Camera) {
            imagePicker.mediaTypes = allmedia
        }
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        chooseImagesFromPhotoLibButton.setTitle("Choose Video", forState: .Normal)
        playHologramButton.setTitle("Play", forState: .Normal)
        
        let stackView = UIStackView(arrangedSubviews: [chooseImagesFromPhotoLibButton, playHologramButton])
        stackView.alignment = .Fill
        stackView.distribution = .EqualCentering
        stackView.axis = .Vertical
        stackView.spacing = 20
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 0).active = true
        stackView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 0).active = true
        
        chooseImagesFromPhotoLibButton.addTarget(self, action: #selector(chooseImgButtonPressed), forControlEvents: .TouchUpInside)
    }
    
    func chooseImgButtonPressed() {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
}

