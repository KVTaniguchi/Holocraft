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
    let closeButton = UIButton(type: .Custom)
    
    let engine = CameraEngine()
    let testView = UIView()
    
    let topMask = UIView()
    let leftMask = UIView()
    let rightMask = UIView()
    let bottomMask = UIView()
    
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    
    var videoURL: NSURL?
    var videoCaptured: (NSURL? -> Void)?

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
        
        engine.blockCompletionFaceDetection = {[weak self] faceObject in
            guard let startingTime = HCFaceFramesManager.shared.startTime, strongSelf = self else { return }
            let hcFaceObj = HCFaceObject(recordedDate: NSDate(), faceObj: faceObject, baseStartDate: startingTime)
            if strongSelf.engine.isRecording {
                HCFaceFramesManager.shared.hcFaceObjects.append(hcFaceObj)
            }
            
            guard let weakSelf = self else { return }
            let frameFace = (faceObject as AVMetadataObject).bounds
            weakSelf.displayLayerDetection(frameFace)
        }
        
        testView.backgroundColor = UIColor.clearColor()
        testView.layer.borderWidth = 1.0
        testView.layer.borderColor = UIColor.redColor().CGColor
        cameraView.addSubview(testView)
    }
    
    func recordButtonPressed() {
        takePictureButton.selected = !takePictureButton.selected
        closeButton.enabled = false
        
        if takePictureButton.selected {
            guard let url = CameraEngineFileManager.documentPath("video.mp4") else { return }
            HCFaceFramesManager.shared.hcFaceObjects.removeAll()
            HCFaceFramesManager.shared.startTime = NSDate()
            engine.startRecordingVideo(url, blockCompletion: {[weak self] (url, error) -> (Void) in
                guard let strongSelf = self else { return }
                HCFaceFramesManager.shared.stopTime = NSDate()
                strongSelf.videoURL = url
                strongSelf.videoCaptured?(url)
            })
        }
        else {
            engine.stopRecordingVideo()
            closeButton.enabled = true
        }
    }
    
    func closeButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
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
