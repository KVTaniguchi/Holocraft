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

class HCViewHologramsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    let key = "com.Holocraft.videos"
    var collectionView: UICollectionView?
    
    var results: PHFetchResult?
    private var urls = [NSURL]()

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
        cv.delegate = self
        cv.dataSource = self
        cv.registerClass(HCVideoCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(cv)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        generateURLsFromSavedVideoURLStrings()
        guard let cv = collectionView else { return }
        cv.reloadData()
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? HCVideoCell, res = results else { return UICollectionViewCell() }
        if indexPath.item < urls.count {
            let url = urls[indexPath.item]
            
            
            guard let result = res[indexPath.item] as? PHAsset else { return UICollectionViewCell() }
            let id = PHImageManager.defaultManager().requestAVAssetForVideo(result, options: nil, resultHandler: { (video, audio, info) in
                guard let ass = video else { return }
                let generator = AVAssetImageGenerator(asset: ass)
                generator.appliesPreferredTrackTransform = true
                do {
                    let cgImg = try generator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
                    let image = UIImage(CGImage: cgImg)
                    cell.imageView.image = image
                }
                catch {
                    print("Warning: failed to fetch image from video err \(error) asdfasd")
                }
            })
            
            
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let res = results else { return 0 }
        return res.countOfAssetsWithMediaType(.Video)
    }
    
    func generateURLsFromSavedVideoURLStrings() {
        guard let videoURLStrings = NSUserDefaults.standardUserDefaults().objectForKey(key) as? [String] else { return }
        
        for string in videoURLStrings {
            if let url = NSURL(string: string) {
                print(url.absoluteString)
                    urls.append(url)
                
            }
            
        }
    }
}

class HCVideoCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = frame
        imageView.contentMode = .ScaleAspectFit
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}