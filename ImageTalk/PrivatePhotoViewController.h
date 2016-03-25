//
//  PrivatePhotoViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 12/2/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIPImageCropperView.h"

@interface PrivatePhotoViewController : UIViewController<UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (assign, nonatomic) CGFloat initialZoomLevel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *body;
@property (strong, nonatomic) HIPImageCropperView *cropperImage;
@property (strong, nonatomic) IBOutlet UIView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UIView *popUp;
@property (strong, nonatomic) IBOutlet UIImageView *popUpImage;

@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) int timer;

@end
