//
//  ProfileViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterUiButton.h"
#import "AppDelegate.h"
#import "StatusResponse.h"
#import "ApiAccess.h"

@interface ProfileViewController : UIViewController<ApiAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}


@property (strong, nonatomic) IBOutlet UILabel *wallpost;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (strong, nonatomic) IBOutlet UITextField *textStaus;
@property (strong, nonatomic)  AppDelegate *app;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *picCount;
@property (strong, nonatomic) UIImage  *pic;
@property (strong, nonatomic) StatusResponse  *response;


@end
