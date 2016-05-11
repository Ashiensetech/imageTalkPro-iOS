//
//  UploadMoodViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/10/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactResponse.h"
#import "CreatePostResponse.h"
#import "ApiAccess.h"

@interface UploadMoodViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,ApiAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (nonatomic,strong) CreatePostResponse *responseCreate;
@property (strong, nonatomic) NSMutableArray *myObjectSelection;
@property (strong, nonatomic) NSMutableArray *myObject;
@property (strong, nonatomic) ContactResponse *response;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) IBOutlet UITableView *tableData;
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pictureHeight;
@property (strong, nonatomic) NSString *keyword;
@property (assign,nonatomic) int offset;
@property (assign,nonatomic) BOOL isData;
@property (assign,nonatomic) BOOL loaded;
@property (strong, nonatomic) IBOutlet UITextField *customMsg;

@property (assign,nonatomic) BOOL selected;

@property (assign,nonatomic) int type;
@property (strong, nonatomic) UIImage *pic;

@property (assign,nonatomic) CGPoint tabPosition;
@property (strong,nonatomic)NSMutableArray *tagPostions;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeight;

@end
