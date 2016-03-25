//
//  ChatDetailsViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/17/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tcpSocketChat.h"
#import "SocektAccess.h"
#import "SocketResponse.h"
#import "AppDelegate.h"
#import "ChatPhoto.h"
#import "TimerAccess.h"

@interface ChatDetailsViewController : UIViewController<UIGestureRecognizerDelegate, UIScrollViewDelegate,TimeAccessDelegate,tcpSocketChatDelegate>
{
    
        NSUserDefaults *defaults;
        NSString *baseurl;
        NSString *socketurl;
        NSString *port;
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) UIImage* image;
@property (strong, nonatomic) IBOutlet UIImageView *body;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (assign, nonatomic) CGFloat initialZoomLevel;
@property (assign,nonatomic) BOOL isPrivate;
@property (strong, nonatomic) IBOutlet UILabel *privatePhoto;
@property (strong, nonatomic) tcpSocketChat *chatSocket;
@property (strong, nonatomic) AppDelegate *app;
@property (strong,nonatomic)  ChatPhoto* data;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *startTime;
@property (assign, nonatomic) BOOL isDeleted;
@property (assign, nonatomic) BOOL isRunning;
@property (assign, nonatomic) int timerValue;
@property (assign, nonatomic) int interval;

@end
