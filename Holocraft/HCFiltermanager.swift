//
//  HCFiltermanager.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/14/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit
import GPUImage

class HCFiltermanager: UITableViewController {
    
    let filters = [GPUImageToonFilter(), GPUImageRGBFilter(), GPUImagePixellateFilter(), GPUImagePolkaDotFilter(), GPUImageGrayscaleFilter(), GPUImageSketchFilter(), GPUImageGaussianBlurFilter(), GPUImageZoomBlurFilter(), GPUImageSwirlFilter(), GPUImagePinchDistortionFilter(), GPUImageStretchDistortionFilter(), GPUImageMosaicFilter()]
    
    let titles = ["Cartoon", "RGB", "Pixellaet", "Polka Dots", "Gray", "Sketch", "Gauss Blur", "Zoom", "Swirl", "Pinch", "Stretch", "Mosaic"]
    
    var filterSelectedClosure: (GPUImageFilter -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("cell") else { return UITableViewCell() }
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedFilter = filters[indexPath.row]
        filterSelectedClosure?(selectedFilter)
    }
}
