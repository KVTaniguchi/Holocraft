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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine.changeCurrentDevice(.Front)
        engine.rotationCamera = true
        engine.flashMode = .Auto
        engine.torchMode = .Auto
        engine.cameraFocus = .ContinuousAutoFocus
        engine.metadataDetection = .Face
        engine.startSession()
        
        view.backgroundColor = UIColor.whiteColor()
        
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
    
    func displayLayerDetection(frame: CGRect) {
        dispatch_async(dispatch_get_main_queue()) {
            self.testView.alpha = 1.0
            self.testView.frame = frame
            UIView.animateWithDuration(0.1, animations: { 
                self.testView.alpha = 0
            })
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
