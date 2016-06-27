//
//  NotificationViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Response.h"
#import "ApiAccess.h"
#import "NotificationResponse.h"

@interface NotificationViewController : UIViewController<ApiAccessDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
    NSString *socketurl;
    NSString *port;
 

    
}
@property (strong,nonatomic) NotificationResponse * data;
@property (strong,nonatomic) NSMutableArray *notificationsList;
@property (strong, nonatomic) IBOutlet UITableView *notificationTable;
@property (assign,nonatomic) int offset;
@end
