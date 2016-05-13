//
//  SharePhotoViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/2/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatePostResponse.h"
#import "JSONHTTPClient.h"
#import "ApiAccess.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "VKSdk.h" 
@import  MapKit;

@interface SharePhotoViewController : UIViewController <ApiAccessDelegate,UITextViewDelegate,FBSDKSharingDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIDocumentInteractionControllerDelegate,VKSdkDelegate,VKSdkUIDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
    UIImageView *imageMain;
}

@property (strong, nonatomic) IBOutlet UILabel *tagLabel;
@property (strong, nonatomic)  NSMutableArray *myObjectSelection;
@property (strong, nonatomic) IBOutlet UIButton *upload;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (strong,nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UITextField *comment;
@property (strong, nonatomic) CreatePostResponse *response;
@property (strong, nonatomic) Places *place;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionCharLabel;
@property (weak, nonatomic) IBOutlet UIView *facebookShare;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionData;
@property (strong,nonatomic)  NSMutableArray *smilyObject;
@property (nonatomic,assign) NSString *wallPostMood;
@property (strong, nonatomic) AppCredential  *owner;
@property (strong, nonatomic) IBOutlet UIScrollView *containerScroller;
@property (strong, nonatomic) IBOutlet UIView *tagFview;
@property (nonatomic, assign) UIImage *profilePic;
@property (nonatomic, assign) UIImageView *blackView;
@property (strong, nonatomic) IBOutlet UIView *instagramShare;
@property (strong, nonatomic) IBOutlet UIView *VKShare;
@property (strong, nonatomic) IBOutlet UIView *addLocView;
@property (strong, nonatomic) IBOutlet UIButton *tagFriendView;
@property (strong, nonatomic) IBOutlet UITextView *postCaption;
@property(strong,nonatomic) NSString *tagCustomMessage;
@property (strong,nonatomic) NSMutableArray *tagList;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (nonatomic,strong) MKMapItem *postLocation;
@end
