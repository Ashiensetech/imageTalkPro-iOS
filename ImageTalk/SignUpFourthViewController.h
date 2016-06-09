//
//  SignUpFourthViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrationResponse.h"
#import "AssetManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CustomCollectionViewCell.h"
#import "AppDelegate.h"

@interface SignUpFourthViewController : UIViewController  <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,tcpSocketChatDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
    NSString *deviceToken;
}

@property (strong, nonatomic) AppDelegate *app;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (strong, nonatomic) IBOutlet UIScrollView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *next;
@property (strong, nonatomic) IBOutlet UILabel *header;
@property (strong, nonatomic) IBOutlet UIButton *back;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionData;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) UIView *keyboardBorder;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) RegistrationResponse *response;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (weak, nonatomic) IBOutlet UILabel *toast;

@end
