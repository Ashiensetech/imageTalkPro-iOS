//
//  ShareMoodViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/9/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickerResponse.h"
#import "CreatePostResponse.h"
#import "StickerCategoryResponse.h"
#import "PTEHorizontalTableView.h"
#import "ApiAccess.h"

@interface ShareMoodViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ApiAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) IBOutlet UITextField *message;
@property (strong, nonatomic)  NSMutableArray *myObject;
@property (strong, nonatomic)  NSMutableArray *myObjectCategory;
@property (strong, nonatomic)  NSMutableArray *myObjectSelection;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionData;
@property (nonatomic, strong) UIImage *image;
@property (assign,nonatomic) int offset;
@property (assign,nonatomic) BOOL isData;
@property (assign,nonatomic) BOOL loaded;
@property (strong, nonatomic) IBOutlet UIImageView *imageSticker;
@property (strong, nonatomic) IBOutlet UIView *singleView;
@property (nonatomic,strong) CreatePostResponse *responseCreate;
@property (strong, nonatomic) IBOutlet PTEHorizontalTableView *horizontalView;



@property (nonatomic, strong) StickerResponse *response;
@property (nonatomic, strong) StickerCategoryResponse *responseCategory;


@end
