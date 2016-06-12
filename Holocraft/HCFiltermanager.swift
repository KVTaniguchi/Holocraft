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
    
    let titles = ["Cartoon", "RGB", "Pixellate", "Polka Dots", "Gray", "Sketch", "Gauss Blur", "Zoom", "Swirl", "Pinch", "Stretch", "Mosaic"]
    
    var filterSelectedClosure: (GPUImageFilter -> Void)?
    
    let cancelButton = UIButton()
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        titleLabel.text = "Select a Filter"
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.addTarget(self, action: #selector(cancelPressed), forControlEvents: .TouchUpInside)
        cancelButton.setTitleColor(view.tintColor, forState: .Normal)
        cancelButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        let headerView = UIView()
        let stackView = UIStackView(arrangedSubviews: [titleLabel, cancelButton])
        stackView.axis = .Vertical
        stackView.distribution = .EqualSpacing
        stackView.alignment = .Center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(stackView)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[stackView]|", options: [], metrics: nil, views: ["stackView":stackView]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[stackView]|", options: [], metrics: nil, views: ["stackView":stackView]))
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame = CGRectMake(0, 0, headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).width, headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height)
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
    
    func cancelPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
