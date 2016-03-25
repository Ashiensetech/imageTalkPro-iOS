//
//  LikesViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/28/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikesResponse.h"
#import "ApiAccess.h"

@interface LikesViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,ApiAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}

@property (strong, nonatomic)  NSMutableArray *myObject;
@property (nonatomic, assign) int postId;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) IBOutlet UITableView *tableData;
@property (strong, nonatomic) LikesResponse *response;
@property (assign,nonatomic) int offset;
@property (assign,nonatomic) BOOL isData;
@property (assign,nonatomic) BOOL loaded;

@end
