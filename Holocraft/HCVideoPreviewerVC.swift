//
//  HCVideoPreviewerVC.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/8/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class HCVideoPreviewerVC: UIViewController {
    
    let stopButton = UIButton()
    let playButton = UIButton()
    let closeButton = UIButton()
    let previewView = UIView()
    
    private var vidURL = NSURL()
    
    init(videoURL: NSURL){
        super.init(nibName: nil, bundle: nil)
        vidURL = videoURL
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let views = ["stop": stopButton, "play": playButton, "close": closeButton, "preview": previewView]
        
        for subView in views.values {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        closeButton.addTarget(self, action: #selector(dismiss), forControlEvents: .TouchUpInside)
        playButton.addTarget(self, action: #selector(play), forControlEvents: .TouchUpInside)
        
        stopButton.setTitle("Pause", forState: .Normal)
        playButton.setTitle("Play", forState: .Normal)
        closeButton.setTitle("Close", forState: .Normal)
        
        for button in [stopButton, playButton, closeButton] {
            button.setTitleColor(view.tintColor, forState: .Normal)
            button.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
            button.backgroundColor = UIColor.blackColor()
        }
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[preview][stop(44)]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[preview]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[stop][play(stop)][close(stop)]|", options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: views))
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
 
    func play() {
        if let layers = previewView.layer.sublayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
        playVideo(vidURL)
    }

    private func playVideo(url: NSURL) {
        let player = AVPlayer(URL: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = previewView.bounds
        previewView.layer.insertSublayer(playerLayer, atIndex: 0)
        
        let playDate = NSDate()
        for hcFaceObj in HCFaceFramesManager.shared.hcFaceObjects {
            hcFaceObj.createCallDateFrom(playDate)
            if let date = hcFaceObj.callDate {
                let timerObject = NSTimer(fireDate: date, interval: 0, target: self, selector: #selector(fireFrame(_:)), userInfo: hcFaceObj, repeats: false)
                timerObject.tolerance = 0.1
                NSRunLoop.currentRunLoop().addTimer(timerObject, forMode: NSDefaultRunLoopMode)
                HCFaceFramesManager.shared.timeObjects[timerObject] = hcFaceObj
            }
        }
        
        player.play()
    }
    
    func fireFrame(timer: NSTimer) {
        if let hcFaceObj = HCFaceFramesManager.shared.timeObjects[timer], faceObj = hcFaceObj.associatedFaceObject {
            timer.invalidate()
            var frame = (faceObj as AVMetadataObject).bounds
            frame.origin.x -= 20
            frame.size.width += 20
            frame.origin.y -= 100
            frame.size.height += 100
            
            let w  = UIScreen.mainScreen().bounds.width
            let h = UIScreen.mainScreen().bounds.height
            
            let top = UIView()
            let left = UIView()
            let right = UIView()
            let bottom = UIView()
            
            let views = [left, top, bottom, right]
            
            views.forEach { view in
                view.backgroundColor = UIColor.blackColor()
                previewView.addSubview(view)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                UIView.animateWithDuration(0.01, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                    top.frame = CGRectMake(0, 0, w, frame.origin.y)
                    bottom.frame = CGRectMake(0, CGRectGetMaxY(frame), w, h - CGRectGetMaxY(frame))
                    left.frame = CGRectMake(0, frame.origin.y, frame.origin.x, frame.height)
                    right.frame = CGRectMake(CGRectGetMaxX(frame), frame.origin.y, w - CGRectGetMaxX(frame), frame.height)
                    }, completion: { complete in
                        UIView.animateWithDuration(0.1, animations: {
                            views.forEach({ (view) in
                                view.alpha = 0.0
                            })
                            }, completion: { (complete) in
                                views.forEach({ (view) in
                                    view.removeFromSuperview()
                                })
                        })
                    })
            }
        }
    }

}
