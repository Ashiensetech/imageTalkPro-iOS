//
//  AdjustPhotoViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/26/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIPImageCropperView.h"

@interface AdjustPhotoViewController : UIViewController

@property (strong,nonatomic) UIImage *image;
@property (strong, nonatomic)  HIPImageCropperView *cropperImage;
@property (strong, nonatomic) IBOutlet UIView *cropView;
@property (nonatomic, assign) BOOL isTimeline;
@property (nonatomic, assign) BOOL isAspect;
@property (strong, nonatomic) IBOutlet UIButton *adjustFitBtn;

@end
