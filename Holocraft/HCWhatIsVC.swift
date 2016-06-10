//
//  HCWhatIsVC.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 6/10/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit

class HCWhatIsVC: UIViewController {
    let whatIsDetailText = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Holograms"
        view.backgroundColor = UIColor.whiteColor()
        
        whatIsDetailText.translatesAutoresizingMaskIntoConstraints = false
        whatIsDetailText.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        view.addSubview(whatIsDetailText)
        
        whatIsDetailText.text = "This is example text for this view This is example text for this view This is example text for this view This is example text for this view This is example text for this view"
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-40-[detail]-40-|", options: [], metrics: nil, views: ["detail": whatIsDetailText]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-40-[detail]-40-|", options: [], metrics: nil, views: ["detail": whatIsDetailText]))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
