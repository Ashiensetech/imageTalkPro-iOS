//
//  ChatHomeViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 9/22/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatHistoryResponse.h"
#import "tcpSocketChat.h"
#import "AppDelegate.h"
#import "ApiAccess.h"
#import "TimerAccess.h"

@interface ChatHomeViewController : UIViewController<tcpSocketChatDelegate,ApiAccessDelegate,TimeAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
    NSString *socketurl;
    NSString *port;
    NSIndexPath *conversationIndex;
}

@property (assign,nonatomic) int offset;
@property (assign,nonatomic) BOOL isData;
@property (assign,nonatomic) BOOL loaded;
@property (strong, nonatomic) AppDelegate *app;
@property (strong, nonatomic) NSMutableArray *myObject;
@property (strong, nonatomic) ChatHistoryResponse *response;
@property (strong, nonatomic) tcpSocketChat *chatSocket;

@property (strong, nonatomic) IBOutlet UIView *emptyView;
@property (strong, nonatomic) IBOutlet UITableView *tableData;

@end
