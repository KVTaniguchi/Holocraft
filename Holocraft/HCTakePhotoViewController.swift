//
//  HCTakePhotoViewController.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/3/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit
import GPUImage

class HCTakePhotoViewController: UIViewController, GPUImageVideoCameraDelegate {
    
//    @property(nonatomic,retain) CIDetector*faceDetector;
//    NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
//    self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
//    faceThinking = NO;
    
    
    
    let cameraView = GPUImageView()
    let takePictureButton = UIButton(type: .Custom)
    
    let gpuVideoCamera = GPUImageVideoCamera()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gpuVideoCamera.addTarget(cameraView)
        gpuVideoCamera.delegate = self
        
//        [videoCamera rotateCamera];
//        self.title = @"Face Detection";
//        self.filterSettingsSlider.hidden = YES;
//        
//        [self.filterSettingsSlider setValue:1.0];
//        [self.filterSettingsSlider setMinimumValue:0.0];
//        [self.filterSettingsSlider setMaximumValue:2.0];
//        
//        filter = [[GPUImageSaturationFilter alloc] init];
//        [videoCamera setDelegate:self];
//        break;

        view.backgroundColor = UIColor.whiteColor()
        
        takePictureButton.setTitle("Take Picture", forState: .Normal)
        takePictureButton.backgroundColor = UIColor.orangeColor()
    
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraView)
        takePictureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(takePictureButton)
        let views = ["camera": cameraView, "btn": takePictureButton]
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[camera][btn(55)]|", options: [.AlignAllLeft, .AlignAllRight], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[camera]|", options: [], metrics: nil, views: views))
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        gpuVideoCamera.startCameraCapture()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        
        gpuVideoCamera.stopCameraCapture()
    }
    
    func willOutputSampleBuffer(sampleBuffer: CMSampleBuffer!) {
        print(sampleBuffer)
    }
    
//    #pragma mark - Face Detection Delegate Callback
//    - (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
//    if (!faceThinking) {
//    CFAllocatorRef allocator = CFAllocatorGetDefault();
//    CMSampleBufferRef sbufCopyOut;
//    CMSampleBufferCreateCopy(allocator,sampleBuffer,&sbufCopyOut);
//    [self performSelectorInBackground:@selector(grepFacesForSampleBuffer:) withObject:CFBridgingRelease(sbufCopyOut)];
//    }
//    }
//    
//    - (void)grepFacesForSampleBuffer:(CMSampleBufferRef)sampleBuffer{
//    faceThinking = TRUE;
//    NSLog(@"Faces thinking");
//    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
//    CIImage *convertedImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
//    
//    if (attachments)
//    CFRelease(attachments);
//    NSDictionary *imageOptions = nil;
//    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
//    int exifOrientation;
//    
//    /* kCGImagePropertyOrientation values
//     The intended display orientation of the image. If present, this key is a CFNumber value with the same value as defined
//     by the TIFF and EXIF specifications -- see enumeration of integer constants.
//     The value specified where the origin (0,0) of the image is located. If not present, a value of 1 is assumed.
//     
//     used when calling featuresInImage: options: The value for this key is an integer NSNumber from 1..8 as found in kCGImagePropertyOrientation.
//     If present, the detection will be done based on that orientation but the coordinates in the returned features will still be based on those of the image. */
//    
//    enum {
//    PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
//    PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.
//    PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
//    PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
//    PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
//    PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
//    PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
//    PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
//    };
//    BOOL isUsingFrontFacingCamera = FALSE;
//    AVCaptureDevicePosition currentCameraPosition = [videoCamera cameraPosition];
//    
//    if (currentCameraPosition != AVCaptureDevicePositionBack)
//    {
//    isUsingFrontFacingCamera = TRUE;
//    }
//    
//    switch (curDeviceOrientation) {
//    case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
//    exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
//    break;
//    case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
//    if (isUsingFrontFacingCamera)
//				exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
//    else
//				exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
//    break;
//    case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
//    if (isUsingFrontFacingCamera)
//				exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
//    else
//				exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
//    break;
//    case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
//    default:
//    exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
//    break;
//    }
//    
//    imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:exifOrientation] forKey:CIDetectorImageOrientation];
//    
//    NSLog(@"Face Detector %@", [self.faceDetector description]);
//    NSLog(@"converted Image %@", [convertedImage description]);
//    NSArray *features = [self.faceDetector featuresInImage:convertedImage options:imageOptions];
//    
//    
//    // get the clean aperture
//    // the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
//    // that represents image data valid for display.
//    CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
//    CGRect clap = CMVideoFormatDescriptionGetCleanAperture(fdesc, false /*originIsTopLeft == false*/);
//    
//    
//    [self GPUVCWillOutputFeatures:features forClap:clap andOrientation:curDeviceOrientation];
//    faceThinking = FALSE;
//    
//    }
//    
//    - (void)GPUVCWillOutputFeatures:(NSArray*)featureArray forClap:(CGRect)clap
//    andOrientation:(UIDeviceOrientation)curDeviceOrientation
//    {
//    dispatch_async(dispatch_get_main_queue(), ^{
//    NSLog(@"Did receive array");
//    
//    CGRect previewBox = self.view.frame;
//    
//    if (featureArray == nil && faceView) {
//    [faceView removeFromSuperview];
//    faceView = nil;
//    }
//    
//    
//    for ( CIFaceFeature *faceFeature in featureArray) {
//    
//    // find the correct position for the square layer within the previewLayer
//    // the feature box originates in the bottom left of the video frame.
//    // (Bottom right if mirroring is turned on)
//    NSLog(@"%@", NSStringFromCGRect([faceFeature bounds]));
//    
//    //Update face bounds for iOS Coordinate System
//    CGRect faceRect = [faceFeature bounds];
//    
//    // flip preview width and height
//    CGFloat temp = faceRect.size.width;
//    faceRect.size.width = faceRect.size.height;
//    faceRect.size.height = temp;
//    temp = faceRect.origin.x;
//    faceRect.origin.x = faceRect.origin.y;
//    faceRect.origin.y = temp;
//    // scale coordinates so they fit in the preview box, which may be scaled
//    CGFloat widthScaleBy = previewBox.size.width / clap.size.height;
//    CGFloat heightScaleBy = previewBox.size.height / clap.size.width;
//    faceRect.size.width *= widthScaleBy;
//    faceRect.size.height *= heightScaleBy;
//    faceRect.origin.x *= widthScaleBy;
//    faceRect.origin.y *= heightScaleBy;
//    
//    faceRect = CGRectOffset(faceRect, previewBox.origin.x, previewBox.origin.y);
//    
//    if (faceView) {
//    [faceView removeFromSuperview];
//    faceView =  nil;
//    }
//    
//    // create a UIView using the bounds of the face
//    faceView = [[UIView alloc] initWithFrame:faceRect];
//    
//    // add a border around the newly created UIView
//    faceView.layer.borderWidth = 1;
//    faceView.layer.borderColor = [[UIColor redColor] CGColor];
//    
//    // add the new view to create a box around the face
//    [self.view addSubview:faceView];
//    
//    }
//    });
//    
//    }
//    
//    -(IBAction)facesSwitched:(UISwitch*)sender{
//    if (![sender isOn]) {
//    [videoCamera setDelegate:nil];
//    if (faceView) {
//    [faceView removeFromSuperview];
//    faceView = nil;
//    }
//    }else{
//    [videoCamera setDelegate:self];
//    
//    }
//    }

}
