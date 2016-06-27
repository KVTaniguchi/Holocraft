//
//  Convenience.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 6/26/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    
    func makeBlurImage() {
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
    }
    
}

let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height

func isIPad() -> Bool {
    return screenHeight > 736
}