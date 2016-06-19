//
//  HCHologramPlayerViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/14/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit
import GPUImage

class HCHologramPlayerViewController: UIViewController {
    
    private var image: UIImage?
    private var movieURL: NSURL?
    
    var leftView = GPUImageView()
    var rightView = GPUImageView()
    var topView = GPUImageView()
    var bottomView = GPUImageView()
    
    let closeButton = UIButton()
    let filterButton = UIButton()
    
    var currentFilter: GPUImageFilter?
    
    convenience init(img: UIImage) {
        self.init()
        
        image = img
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blackColor()
        
        for btn in [closeButton, filterButton] {
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setTitleColor(view.tintColor, forState: .Normal)
            btn.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
            view.addSubview(btn)
        }
        
        closeButton.setTitle("Close", forState: .Normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), forControlEvents: .TouchUpInside)
        closeButton.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant:  20).active = true
        closeButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -20).active = true
        
        filterButton.setTitle("Apply a Filter", forState: .Normal)
        filterButton.addTarget(self, action: #selector(filterButtonPressed), forControlEvents: .TouchUpInside)
        filterButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -20).active = true
        filterButton.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -20).active = true
        
        guard let url = movieURL else {
            setUpImageViews()
            return }
        
        gpuMovieFile = GPUImageMovie(URL: url)
        gpuMovieFile?.shouldRepeat = true
        let defaultFilter = GPUImageFilter()
        currentFilter = defaultFilter
        gpuMovieFile?.addTarget(defaultFilter)
        for gpuView in [leftView, rightView, topView, bottomView] {
            gpuView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
            defaultFilter.addTarget(gpuView)
        }
        
        gpuMovieFile?.startProcessing()
        
        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        
        rightView.rotate(angle: 180)
        bottomView.setInputRotation(kGPUImageRotateRight, atIndex: 0)
        bottomView.rotate(angle: 180)
        topView.setInputRotation(kGPUImageRotateRight, atIndex: 0)
        
        let views = ["left": leftView, "right": rightView, "top": topView, "bot": bottomView, "guide": layoutGuide]
        
        let horizontalGuideWidth = UIScreen.mainScreen().bounds.width - 200
        let verticalConstant = horizontalGuideWidth
        let metrics = ["imgH": 100, "vertPadding": verticalConstant]
        
        for videoView in [leftView, rightView, topView, bottomView] {
            videoView.backgroundColor = UIColor.orangeColor()
            videoView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(videoView)
        }
        
        layoutGuide.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 0).active = true
        layoutGuide.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 0).active = true
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[left(imgH)][guide(90)][right(imgH)]", options: [.AlignAllCenterY], metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[top(imgH)][guide(90)][bot(imgH)]", options: [.AlignAllCenterX], metrics: metrics, views: views))
        
        for view in [leftView, rightView] {
            view.heightAnchor.constraintEqualToConstant(60).active = true
        }
        for view in [topView, bottomView] {
            view.widthAnchor.constraintEqualToConstant(60).active = true
        }
    }
    
    func setUpImageViews()  {
        
    }
    
    func filterButtonPressed() {
        let filterController = HCFiltermanager()
        presentViewController(filterController, animated: true, completion: nil)
        
        filterController.filterSelectedClosure = {[weak self] filter in
            guard let strongSelf = self else { return }
            strongSelf.gpuMovieFile?.removeTarget(strongSelf.currentFilter)
            strongSelf.currentFilter = filter
            strongSelf.gpuMovieFile?.addTarget(filter)
            
            for gpuView in [strongSelf.topView, strongSelf.bottomView, strongSelf.rightView, strongSelf.leftView] {
                gpuView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
                filter.addTarget(gpuView)
            }
            strongSelf.orientViews()
            strongSelf.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func closeButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func orientViews() {
        bottomView.setInputRotation(kGPUImageRotateRight, atIndex: 0)
        topView.setInputRotation(kGPUImageRotateRight, atIndex: 0)
    }

}

extension UIView {
    func rotate(angle angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat(M_PI)
        let rotation = CGAffineTransformRotate(self.transform, radians);
        self.transform = rotation
    }
    
}
