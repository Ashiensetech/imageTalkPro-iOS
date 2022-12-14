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
#import "BJImageCropper.h"
#import "BFCropInterface.h"

@interface EditPhotoViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ApiAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
    NSMutableArray *stickerArray;
}
@property (strong, nonatomic) IBOutlet UIButton *effectBtn;
@property (strong, nonatomic) IBOutlet UIButton *lipsBtn;
@property (strong, nonatomic) IBOutlet UIButton *smilyBtn;
@property (strong, nonatomic) IBOutlet UIButton *frameBtn;
@property (strong, nonatomic) IBOutlet UIImageView *body;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bodyHeight;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionData;
@property (strong, nonatomic) HIPImageCropperView *cropperImage;
@property (strong, nonatomic) AppDelegate *app;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (strong,nonatomic)  ChangePhotoResponse *response;
@property (strong,nonatomic)  UIImage *image;
@property (strong,nonatomic)  UIImage *thumbImage;
@property (strong,nonatomic)  NSMutableArray *effectObject;
@property (strong,nonatomic)  NSMutableArray *borderObject;
@property (strong,nonatomic)  NSMutableArray *lipsObject;
@property (strong,nonatomic)  NSMutableArray *smilyObject;
@property (strong, nonatomic) IBOutlet UIButton *orientationBtn;
@property (nonatomic, assign) BOOL isTimeline;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL isAspect;
@property (nonatomic,strong)  UIImage *imageHolder;
@property (strong, nonatomic) IBOutlet UIButton *adjustFitBtn;
@property (strong, nonatomic) IBOutlet UIView *cropView;
@property(nonatomic,assign)   BOOL stickered;

//BJImageCropper items
//@property (nonatomic, strong) BJImageCropper *imageCropper;
@property (nonatomic, strong) BFCropInterface *imageCropper;

@property (nonatomic, strong) UIImageView *preview;
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet UIImageView *scaleImage;
@property (strong ,nonatomic)  UIImageView * pointer;

@property (strong,nonatomic)  UIImage *rotatedImage;
@property (nonatomic,assign) CGFloat lastContentOffset;
@property (nonatomic,assign) int currentScrollDirection;
@property (nonatomic,assign) int lastScrollDirection;


@end
