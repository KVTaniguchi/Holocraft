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
    let hologramImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Holograms"
        view.backgroundColor = UIColor.blackColor()
        
        whatIsDetailText.translatesAutoresizingMaskIntoConstraints = false
        whatIsDetailText.font = UIFont(name: "Avenir", size: 14)
        whatIsDetailText.textColor = UIColor.whiteColor()
        whatIsDetailText.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        view.addSubview(whatIsDetailText)
        
        hologramImage.translatesAutoresizingMaskIntoConstraints = false
        hologramImage.image = UIImage(named: "hologramexample")
        hologramImage.contentMode = .ScaleAspectFit
        view.addSubview(hologramImage)
        
        whatIsDetailText.text = "What’s going on is a variation of an old illusion technique used in theaters and haunted houses known as Pepper’s Ghost.   \n\nPepper’s ghosts are created via a sheet of material that is both semi transparent and semi reflective in nature; usually either glass or plexiglass.  When  you place an object on one side of the material, most of the light that bounces off that object passes through.  \n\nHowever, if the object is very bright, and the space on the other side of the material is dark (think about standing in your kitchen with the shades open at night) the glass reflects a much larger portion of the light and you see an image much like you see in a mirror.  Because the image is a reflection, it appears to be coming from BEHIND the glass. Also because it is a reflection, it appears 3 dimensional; meaning that if you move your head or eyes, you see another angle and it looks very real, if dim."
        
        let views = ["detail": whatIsDetailText, "img": hologramImage]
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-40-[detail]-40-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[img(200)][detail]-20-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[img]-|", options: [], metrics: nil, views: views))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
