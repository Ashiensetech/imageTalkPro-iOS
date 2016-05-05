//
//  TimelineViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineResponse.h"
#import "JSONHTTPClient.h"
#import "TimelineTableViewCell.h"
#import "LikeResponse.h"
#import "FavResponse.h"
#import "tcpSocketChat.h"
#import "SocektAccess.h"
#import "Response.h"
#import "ApiAccess.h"


@interface TimelineViewController : UIViewController  <UITableViewDelegate,UITableViewDataSource,tcpSocketChatDelegate,ApiAccessDelegate,UITabBarControllerDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
    NSString *socketurl;
    NSString *port;
    
}
@property (strong, nonatomic) UIAlertView *alertDownload;
@property (strong, nonatomic) UIAlertView *alertDelete;
@property (strong, nonatomic) IBOutlet UIView *emptyView;
@property (strong, nonatomic) AppDelegate *app;
@property (strong, nonatomic) tcpSocketChat *chatSocket;
@property (strong, nonatomic)  NSMutableArray *myObject;
@property (strong, nonatomic) IBOutlet UITableView *tableData;
@property (strong,nonatomic) TimelineResponse *data;
@property (strong,nonatomic) LikeResponse *dataLike;
@property (strong,nonatomic) FavResponse *dataFav;
@property (strong,nonatomic) Response *dataDelete;
@property (assign,nonatomic) int offset;
@property (assign,nonatomic) BOOL isData;
@property (assign,nonatomic) BOOL loaded;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (assign,nonatomic) BOOL updateWill;
@property (assign,nonatomic) int updateId;
@property (assign,nonatomic) int updateValue;
@property (weak, nonatomic) IBOutlet UILabel *toast;







@end
