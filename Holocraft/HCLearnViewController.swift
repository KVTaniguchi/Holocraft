//
//  HCLearnViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/2/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit

class HCLearnViewController: UIViewController {
    
    let blurredBackground = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurredBackground.image = UIImage(named: "IMG_1292")
        blurredBackground.translatesAutoresizingMaskIntoConstraints = false
        blurredBackground.makeBlurImage()
        view.addSubview(blurredBackground)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))

        title = "Learn"
        view.backgroundColor = UIColor(red: 41/255, green: 79/255, blue: 109/255, alpha: 1.0)
    }
}


class HCLearningPanelView: UIView {
    let imageView = UIImageView()
    let headerText = UILabel()
    let detailText = UILabel()
    let disclosureView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let views = ["image": imageView, "header": headerText, "detail": detailText, "disc": disclosureView]
        
        for subView in views.values {
            subView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subView)
        }
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[image(100)][header][disc(50)]|", options: [.AlignAllTop], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[image(100)]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[disc(100)]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[header][detail]|", options: [], metrics: nil, views: views))
    }
    
    func configure(img: UIImage, header: String, detail: String) {
        imageView.image = img
        headerText.text = header
        detailText.text = detail
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}