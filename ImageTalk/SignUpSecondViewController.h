//
//  SignUpSecondViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryResponse.h"
#import "Response.h"


@interface SignUpSecondViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) IBOutlet UIButton *back;
@property (strong, nonatomic) IBOutlet UIButton *next;
@property (strong, nonatomic) IBOutlet UIButton *cancel;
@property (strong, nonatomic) IBOutlet UILabel *header;
@property (strong, nonatomic) IBOutlet UITextField *phoneNo;
@property (assign, nonatomic) int countryCode;
@property (strong, nonatomic) IBOutlet UIButton *country;
@property (strong, nonatomic) UIView *keyboardBorder;
@property (strong, nonatomic) IBOutlet UITableView *tableData;
@property (strong, nonatomic) CountryResponse *data;
@property (strong, nonatomic) Response *response;
@property (strong, nonatomic) IBOutlet UIScrollView *allData;

@end
