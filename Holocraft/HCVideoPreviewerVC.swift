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
        
        
        previewView.backgroundColor = UIColor.purpleColor()
        
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
        }
        player.play()
    }

}
