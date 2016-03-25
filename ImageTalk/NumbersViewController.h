//
//  NumbersViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/19/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactResponse.h"
#import "ApiAccess.h"

@interface NumbersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ApiAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}

@property (strong, nonatomic)  NSMutableArray *myObject;
@property (strong, nonatomic) IBOutlet UITableView *tableData;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) ContactResponse *response;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (assign,nonatomic) int offset;
@property (assign,nonatomic) BOOL isData;
@property (assign,nonatomic) BOOL loaded;
@property (strong, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSString *url;

@end
