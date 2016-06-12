//
//  HCTipsViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 6/12/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit

class HCTipsViewController: UIViewController {
    let tipsText = UITextView()
    let hologramImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Holograms"
        view.backgroundColor = UIColor.blackColor()
        
        tipsText.translatesAutoresizingMaskIntoConstraints = false
        tipsText.font = UIFont(name: "Avenir", size: 14)
        tipsText.textColor = UIColor.whiteColor()
        tipsText.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        view.addSubview(tipsText)
        
        hologramImage.translatesAutoresizingMaskIntoConstraints = false
        hologramImage.image = UIImage(named: "hologramexample")
        hologramImage.contentMode = .ScaleAspectFit
        view.addSubview(hologramImage)
        
        tipsText.text = "Place the Pepper gram projector, small side down, between all four images."
        
        let views = ["detail": tipsText, "img": hologramImage]
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-40-[detail]-40-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[img(200)][detail]-20-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[img]-|", options: [], metrics: nil, views: views))
    }
}
