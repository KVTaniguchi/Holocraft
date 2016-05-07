//
//  HCTakePhotoViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/3/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit
import CameraEngine
import AVFoundation

class HCTakePhotoViewController: UIViewController {

    var faceView = UIView()
    
    let cameraView = UIView()
    let takePictureButton = UIButton(type: .Custom)
    
    let engine = CameraEngine()
    let testView = UIView()
    
    let topMask = UIView()
    let leftMask = UIView()
    let rightMask = UIView()
    let bottomMask = UIView()
    
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine.changeCurrentDevice(.Front)
        engine.rotationCamera = true
        engine.flashMode = .Auto
        engine.torchMode = .Auto
        engine.cameraFocus = .ContinuousAutoFocus
        engine.metadataDetection = .Face
        engine.startSession()
        
        screenWidth = UIScreen.mainScreen().bounds.width
        screenHeight = UIScreen.mainScreen().bounds.height
        
        view.backgroundColor = UIColor.whiteColor()
        
        [topMask, leftMask, rightMask, bottomMask].forEach { view in
            view.backgroundColor = UIColor.blackColor()
            cameraView.addSubview(view)
        }
        
        takePictureButton.setTitle("Take Picture", forState: .Normal)
        takePictureButton.backgroundColor = UIColor.orangeColor()
    
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraView)
        takePictureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(takePictureButton)
        let views = ["camera": cameraView, "btn": takePictureButton]
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[camera][btn(55)]|", options: [.AlignAllLeft, .AlignAllRight], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[camera]|", options: [], metrics: nil, views: views))
        
        engine.blockCompletionFaceDetection = {[weak self] faceObject in
            guard let weakSelf = self else { return }
            let frameFace = (faceObject as AVMetadataObject).bounds
            weakSelf.displayLayerDetection(frameFace)
        }
        
        testView.backgroundColor = UIColor.clearColor()
        testView.layer.borderWidth = 1.0
        testView.layer.borderColor = UIColor.redColor().CGColor
        cameraView.addSubview(testView)
    }
    
    func displayLayerDetection(hardFrame: CGRect) {
        var frame = hardFrame
        frame.origin.x -= 20
        frame.size.width += 20
        frame.origin.y -= 100
        frame.size.height += 100
        dispatch_async(dispatch_get_main_queue()) {
            self.testView.alpha = 1.0
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.testView.frame = frame
                self.testView.alpha = 0
                
                self.topMask.frame = CGRectMake(0, 0, self.screenWidth, frame.origin.y)
                self.bottomMask.frame = CGRectMake(0, CGRectGetMaxY(frame), self.screenWidth, self.screenHeight - CGRectGetMaxY(frame))
                self.leftMask.frame = CGRectMake(0, frame.origin.y, frame.origin.x, frame.height)
                self.rightMask.frame = CGRectMake(CGRectGetMaxX(frame), frame.origin.y, self.screenWidth - CGRectGetMaxX(frame), frame.height)
            }, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layer = engine.previewLayer
        
        layer.frame = cameraView.bounds
        
        cameraView.layer.insertSublayer(layer, atIndex: 0)
        cameraView.layer.masksToBounds = true
    }



}
