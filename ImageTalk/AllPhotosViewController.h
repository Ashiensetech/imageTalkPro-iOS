//
//  AllPhotosViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/2/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "HIPImageCropperView.h"

@interface AllPhotosViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *assetsR;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, assign) BOOL isTimeline;

@property (strong, nonatomic)  HIPImageCropperView *cropperImage;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionData;



@end
