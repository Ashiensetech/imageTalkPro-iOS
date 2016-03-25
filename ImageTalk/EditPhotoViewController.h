//
//  EditPhotoViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/2/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangePhotoResponse.h"
#import "AppDelegate.h"
#import "ApiAccess.h"
#import "HIPImageCropperView.h"

@interface EditPhotoViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ApiAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}
@property (strong, nonatomic) IBOutlet UIButton *effectBtn;
@property (strong, nonatomic) IBOutlet UIButton *lipsBtn;
@property (strong, nonatomic) IBOutlet UIButton *smilyBtn;
@property (strong, nonatomic) IBOutlet UIButton *frameBtn;
@property (strong, nonatomic) IBOutlet UIImageView *body;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bodyHeight;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionData;
@property (strong, nonatomic)  HIPImageCropperView *cropperImage;
@property (strong, nonatomic)  AppDelegate *app;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (strong,nonatomic) ChangePhotoResponse *response;
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) UIImage *thumbImage;
@property (strong,nonatomic) NSMutableArray *effectObject;
@property (strong,nonatomic) NSMutableArray *borderObject;
@property (strong,nonatomic) NSMutableArray *lipsObject;
@property (strong,nonatomic) NSMutableArray *smilyObject;
@property (nonatomic, assign) BOOL isTimeline;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL isAspect;
@property (nonatomic,strong) UIImage *imageHolder;
@property (strong, nonatomic) IBOutlet UIButton *adjustFitBtn;
@property (strong, nonatomic) IBOutlet UIView *cropView;

@end
