//
//  HCHologramPlayerViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/14/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit
import VideoLoopView
import GPUImage

class HCHologramPlayerViewController: UIViewController {
    
    private var image: UIImage?
    private var movieURL: NSURL?
    
    var leftView: VideoLoopView?
    var rightView: VideoLoopView?
    var topView: VideoLoopView?
    var bottomView: VideoLoopView?
    
    let closeButton = UIButton()
    
    convenience init(img: UIImage) {
        self.init()
        
        image = img
    }
    
    convenience init(movie: NSURL) {
        self.init()
        
        movieURL = movie
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.setTitle("Close", forState: .Normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), forControlEvents: .TouchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        closeButton.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        closeButton.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 40).active = true
        closeButton.hidden = true
        
        guard let url = movieURL else {
            setUpImageViews()
            return }
        
        
//        let gpuMovieFile = GPUImageMovie(URL: url)
//        gpuMovieFile.shouldRepeat = true
//        let testFilter = GPUImageSobelEdgeDetectionFilter()
//        gpuMovieFile.addTarget(testFilter)
//        let filteredImageView = GPUImageView()
//        testFilter.addTarget(filteredImageView)
//        filteredImageView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(filteredImageView)
//        filteredImageView.widthAnchor.constraintEqualToConstant(60).active = true
//        filteredImageView.heightAnchor.constraintEqualToConstant(100).active = true
//        filteredImageView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
//        filteredImageView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
//        
//        gpuMovieFile.startProcessing()
        
        
        leftView = VideoLoopView(videoUrl: url)
        rightView = VideoLoopView(videoUrl: url)
        topView = VideoLoopView(videoUrl: url)
        bottomView = VideoLoopView(videoUrl: url)
        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        
        guard let left = leftView, right = rightView, top = topView, bottom = bottomView else { return }
        
        left.playerLayer.transform = CATransform3DScale(CATransform3DMakeRotation(CGFloat(M_PI) / 2.0, 0, 0, 1), -1, -1, 1);
        right.playerLayer.transform = CATransform3DScale(CATransform3DMakeRotation(CGFloat(M_PI) / 2.0, 0, 0, 1), 1, 1, 1);
        bottom.playerLayer.transform = CATransform3DScale(CATransform3DMakeRotation(CGFloat(M_PI), 0, 0, 1), 1, 1, 1);
        
        let views = ["left": left, "right": right, "top": top, "bot": bottom, "guide": layoutGuide]
        
        let horizontalGuideWidth = UIScreen.mainScreen().bounds.width - 200
        let verticalConstant = horizontalGuideWidth
        let metrics = ["imgH": 100, "vertPadding": verticalConstant]
        
        for videoView in [left, right, top, bottom] {
            videoView.backgroundColor = UIColor.orangeColor()
            videoView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(videoView)
        }
        
        layoutGuide.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 0).active = true
        layoutGuide.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 0).active = true
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[left(imgH)][guide][right(imgH)]|", options: [.AlignAllCenterY], metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[top(imgH)][guide(vertPadding)][bot(imgH)]", options: [.AlignAllCenterX], metrics: metrics, views: views))
        
        for view in [left, right] {
            view.heightAnchor.constraintEqualToConstant(60).active = true
        }
        for view in [top, bottom] {
            view.widthAnchor.constraintEqualToConstant(60).active = true
        }
    }
    
    func setUpImageViews()  {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        closeButton.hidden = false
    }
    
    func closeButtonPressed() {
        closeButton.hidden = true
        dismissViewControllerAnimated(true, completion: nil)
    }

}
