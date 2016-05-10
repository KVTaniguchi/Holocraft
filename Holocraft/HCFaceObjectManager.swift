//
//  HCFaceObjectManager.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/7/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import Foundation
import AVFoundation
import CameraEngine

class HCFaceObject: NSObject {
    var associatedFaceObject: AVMetadataFaceObject?
    var date: NSDate?
    var relativeTimeIndex: Double = 0.0
    var callDate: NSDate?
    var timeObject: NSTimer?
    
    init(recordedDate: NSDate, faceObj: AVMetadataFaceObject, baseStartDate: NSDate) {
        date = recordedDate
        associatedFaceObject = faceObj
        relativeTimeIndex = recordedDate.timeIntervalSinceDate(baseStartDate)
    }
    
    func createCallDateFrom(playerStartDate: NSDate) {
        callDate = playerStartDate.dateByAddingTimeInterval(relativeTimeIndex)
    }
}

class HCFaceFramesManager: NSObject {
    static let shared = HCFaceFramesManager()
    var hcFaceObjects = [HCFaceObject]()
    var startTime: NSDate?
    var stopTime: NSDate?
    
    var duration: Double? {
        guard let start = startTime, stop = stopTime else { return nil }
        return stop.timeIntervalSinceDate(start)
    }
    
    var timeObjects = [NSTimer: HCFaceObject]()
}