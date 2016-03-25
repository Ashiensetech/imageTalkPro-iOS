//
//  SignUpThirdViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Response.h"

@interface SignUpThirdViewController : UIViewController
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (strong, nonatomic) IBOutlet UITextField *phoneNo;
@property (strong, nonatomic) UIView *keyboardBorder;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) Response *response;
@property (strong, nonatomic) IBOutlet UIButton *callme;

@end
