//
//  HCViewHologramsViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/2/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CameraEngine
import CameraManager
import Photos

class HCViewHologramsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, PHPhotoLibraryChangeObserver {
    let key = "com.Holocraft.videos"
    var collectionView: UICollectionView?
    var results: PHFetchResult?
    private var videoStills = [UIImage]()
    private var videoAssets = [AVAsset]()
    private var isGeneratingAssets = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults.standardUserDefaults().arrayForKey(key) == nil {
            NSUserDefaults.standardUserDefaults().setObject([String](), forKey: key)
        }
        
        results = PHAsset.fetchAssetsWithMediaType(.Video, options: nil)

        title = "View"
        view.backgroundColor = UIColor.greenColor()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        let itemWidth = UIScreen.mainScreen().bounds.width/2 - 2
        layout.itemSize = CGSizeMake(itemWidth, itemWidth)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        guard let cv = collectionView else { return }
        cv.backgroundColor = UIColor.lightGrayColor()
        cv.delegate = self
        cv.dataSource = self
        cv.registerClass(HCVideoCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(cv)
        
        generateAssets()
    }
    
    func photoLibraryDidChange(changeInstance: PHChange) {
        dispatch_async(dispatch_get_main_queue()) { 
            
            guard let res = self.results, changes = changeInstance.changeDetailsForFetchResult(res) else { return }
            self.results = changes.fetchResultAfterChanges
            self.generateAssets()
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? HCVideoCell else { return UICollectionViewCell() }
        
        let image = videoStills[indexPath.item]
        cell.imageView.image = image
        
        return cell
    }
    
    func generateAssets() {
        guard let res = results where !isGeneratingAssets else { return }
        
        isGeneratingAssets = true
        
        res.enumerateObjectsUsingBlock { (asset, index, stop) in
            PHImageManager.defaultManager().requestAVAssetForVideo(asset as! PHAsset, options: nil, resultHandler: { (video, audio, info) in
                guard let ass = video else { return }
                self.videoAssets.append(ass)
                let generator = AVAssetImageGenerator(asset: ass)
                generator.appliesPreferredTrackTransform = true
                do {
                    let cgImg = try generator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
                    let image = UIImage(CGImage: cgImg)
                    self.videoStills.append(image)
                    
                    if index == res.count - 1 {
                        self.isGeneratingAssets = false
                        self.collectionView?.reloadData()
                        return
                    }
                }
                catch {
                    print("Warning: failed to fetch image from video err \(error) asdfasd")
                }
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoStills.count
    }
}

class HCVideoCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.whiteColor()
        imageView.frame = frame
        imageView.contentMode = .ScaleAspectFit
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}