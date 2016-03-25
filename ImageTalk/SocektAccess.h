//
//  SocektAccess.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/12/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tcpSocketChat.h"
#import "AppDelegate.h"
#import "AuthCredential.h"
#import "ChatTransport.h"
#import "TSocketClient.h"
#import "TBinaryProtocol.h"

@interface SocektAccess : NSObject <tcpSocketChatDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
    NSString *socketurl;
    NSString *port;
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
   // thriftServiceChatTransportClient *server;
   // TSocketClient *transport;
   // TBinaryProtocol *protocol;
}


@property (nonatomic,strong) tcpSocketChat* chatSocket;
@property (nonatomic,assign) id<tcpSocketChatDelegate> delegate;
@property (strong, nonatomic)  AppDelegate *app;
@property (strong, nonatomic)  AuthCredential *authCredetial;
@property (strong, nonatomic)  UITabBarItem *item;
@property (strong, nonatomic)  UITableView *chatData;
@property (assign, nonatomic)  int badgeValue;


+(SocektAccess*)getSharedInstance;

- (void) initSocket;

- (void) authentication;

- (void) setTabBarItem:(UITabBarItem*) item;

- (void) emptyBadge;

- (void) setBadge;

-(void) sendVideoWithContactId:(int) id jsonString:(NSString*) json byteData:(NSData*) data filename:(NSString*) name;

-(void) sendPhotoWithContactId:(int) id jsonString:(NSString*) json byteData:(NSData*) data filename:(NSString*) name;

-(void) sendPrivatePhotoWithContactId:(int) id jsonString:(NSString*) json byteData:(NSData*) data filename:(NSString*) name;

-(void) sendVoiceWithContactId:(int) id jsonString:(NSString*) json byteData:(NSData*) data filename:(NSString*) name;

- (tcpSocketChat*) getSocket;

@end
