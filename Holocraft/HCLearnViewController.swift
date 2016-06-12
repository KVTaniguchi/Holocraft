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
    
    let whatIsAHologramView = HCLearningPanelView()
    let tipsView = HCLearningPanelView()
    let purchaseView = HCLearningPanelView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        whatIsAHologramView.selectionAction = {
            let whatIsVC = HCWhatIsVC()
            self.navigationController?.pushViewController(whatIsVC, animated: true)
        }
        
        tipsView.selectionAction = {
            let tipsVC = HCTipsViewController()
            self.navigationController?.pushViewController(tipsVC, animated: true)
        }
        
        purchaseView.selectionAction = {
            self.tabBarController?.selectedIndex = 3
        }
        
        blurredBackground.image = UIImage(named: "IMG_1292")
        blurredBackground.translatesAutoresizingMaskIntoConstraints = false
        blurredBackground.makeBlurImage()
        view.addSubview(blurredBackground)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blur]|", options: [], metrics: nil, views: ["blur":blurredBackground]))

        title = "Learn"
        view.backgroundColor = UIColor(red: 41/255, green: 79/255, blue: 109/255, alpha: 1.0)
        
        // what
        whatIsAHologramView.headerText.text = NSLocalizedString("What is a Hologram?", comment: "")
        whatIsAHologramView.detailText.text = NSLocalizedString("Learn about the science behind holograms!", comment: "")
        // tips
        tipsView.headerText.text = NSLocalizedString("Tips for making a great hologram", comment: "")
        tipsView.detailText.text = NSLocalizedString("To make a great hologram...", comment: "")
        // purchase
        purchaseView.headerText.text = NSLocalizedString("Purchasing a hologram", comment: "")
        purchaseView.detailText.text = NSLocalizedString("Get your own pepper's ghost by visiting laser classroom", comment: "")
        let views = ["what": whatIsAHologramView, "tips": tipsView, "pur": purchaseView]
        
        views.values.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[what(>=100)]-[tips(>=100)]-[pur(>=100)]", options: [.AlignAllLeft, .AlignAllRight], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-24-[what]-24-|", options: [], metrics: nil, views: views))
        tipsView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
    }
}

class HCLearningPanelView: UIView {
    let imageView = UIImageView()
    let headerText = UILabel()
    let detailText = UILabel()
    let disclosureView = UIImageView()
    var selectionAction: (Void -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
        
        headerText.textColor = UIColor.whiteColor()
        detailText.textColor = UIColor.whiteColor()
        headerText.font = UIFont(name: "Avenir-Bold", size: 20)
        detailText.font = UIFont(name: "Avenir", size: 14)
        headerText.numberOfLines = 0
        detailText.numberOfLines = 0
        headerText.lineBreakMode = .ByWordWrapping
        detailText.lineBreakMode = .ByWordWrapping
        
        let views = ["image": imageView, "header": headerText, "detail": detailText, "disc": disclosureView]
        
        for subView in views.values {
            subView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subView)
        }
        
        if let image = UIImage(named: "forward-50")?.imageWithRenderingMode(.AlwaysTemplate) {
            disclosureView.image = image
            disclosureView.tintColor = UIColor.whiteColor()
        }
        
        backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        
        disclosureView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[image(44)]-[header]-[disc(40)]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[image]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[header(>=30@750)][detail]-|", options: [.AlignAllLeft, .AlignAllRight], metrics: nil, views: views))
    }
    
    func tapAction() {
        selectionAction?()
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