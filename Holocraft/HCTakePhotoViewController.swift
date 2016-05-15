//
//  HCTakePhotoViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/3/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit
import AVFoundation
import CameraEngine

import GPUImage

class HCTakePhotoViewController: UIViewController {

    var faceView = UIView()
    
    let cameraView = GPUImageView()
    let takePictureButton = UIButton(type: .Custom)
    let closeButton = UIButton(type: .Custom)
    
    let testView = UIView()
    
    let topMask = UIView()
    let leftMask = UIView()
    let rightMask = UIView()
    let bottomMask = UIView()
    
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    
    var videoURL: NSURL?
    var videoCaptured: (NSURL? -> Void)?
    
    let gpuCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset640x480, cameraPosition: .Front)
    
    let testFilter = GPUImageSobelEdgeDetectionFilter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gpuCamera.outputImageOrientation = .Portrait
        gpuCamera.addTarget(testFilter)
        gpuCamera.addTarget(cameraView)
        testFilter.addTarget(cameraView)
        
        
        screenWidth = UIScreen.mainScreen().bounds.width
        screenHeight = UIScreen.mainScreen().bounds.height
        
        view.backgroundColor = UIColor.whiteColor()
        
        [topMask, leftMask, rightMask, bottomMask].forEach { view in
            view.backgroundColor = UIColor.blackColor()
            cameraView.addSubview(view)
        }
        
        takePictureButton.setTitle("Record", forState: .Normal)
        takePictureButton.setTitle("Stop", forState: .Selected)
        takePictureButton.backgroundColor = UIColor.orangeColor()
        takePictureButton.addTarget(self, action: #selector(recordButtonPressed), forControlEvents: .TouchUpInside)
        closeButton.setTitle("Close", forState: .Normal)
        closeButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        closeButton.backgroundColor = UIColor.darkGrayColor()
        closeButton.addTarget(self, action: #selector(closeButtonPressed), forControlEvents: .TouchUpInside)
    
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraView)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        takePictureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(takePictureButton)
        let views = ["camera": cameraView, "record": takePictureButton, "close": closeButton]
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[camera][record(44)]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[camera]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[record][close(record)]|", options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: views))
        
        gpuCamera.startCameraCapture()
    }
    
    func recordButtonPressed() {
        takePictureButton.selected = !takePictureButton.selected
        closeButton.enabled = false
        
        guard let url = CameraEngineFileManager.documentPath("video.mp4") else {
            return
        }
        
        if takePictureButton.selected {
            
        }
        else {
            
            closeButton.enabled = true
            
        }
    }
    
    func closeButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
