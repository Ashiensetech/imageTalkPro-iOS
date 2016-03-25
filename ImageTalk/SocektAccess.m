//
//  SocektAccess.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/12/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "SocektAccess.h"
#import "SocketResponse.h"
#import "SocketResponseStat.h"

static SocektAccess *sharedInstance = nil;

@implementation SocektAccess
@synthesize delegate = _delegate;
@synthesize chatSocket = _chatSocket;

+(SocektAccess*)getSharedInstance{
    
    if (!sharedInstance) {
        
        sharedInstance = [[super allocWithZone:NULL]init];
        
    }
    
    return sharedInstance;
}

- (void) initSocket{

    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    socketurl = [defaults objectForKey:@"socketurl"];
    port = [defaults objectForKey:@"port"];
    
    _chatSocket = [[tcpSocketChat alloc] initWithDelegate:_delegate AndSocketHost:socketurl AndPort:[port integerValue]];
    
   // transport = [[TSocketClient alloc] initWithHostname:@"27.147.149.178" port:9028];
  //  protocol  = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
   // server = [[thriftServiceChatTransportClient alloc] initWithProtocol:protocol];
    
    self.app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
   // NSString *token = [server getToken:self.app.authCredential.accessToken];
   // [defaults setValue:token forKey:@"socket_token"];
    
    
}


-(void) sendVideoWithContactId:(int) id jsonString:(NSString*) json byteData:(NSData*) data filename:(NSString*) name
{
    TSocketClient *transport = [[TSocketClient alloc] initWithHostname:@"27.147.149.178" port:9028];
    TBinaryProtocol *protocol  = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    thriftServiceChatTransportClient *server = [[thriftServiceChatTransportClient alloc] initWithProtocol:protocol];
    NSString *token = [server getToken:self.app.authCredential.accessToken];
    [server sendVideo:id token:token socketResponse:json bufferedByte:data fileName:name];
   // [server expireMyToken:self.app.authCredential.id token:token];
    
}

-(void) sendPhotoWithContactId:(int) id jsonString:(NSString*) json byteData:(NSData*) data filename:(NSString*) name
{
    
    TSocketClient *transport = [[TSocketClient alloc] initWithHostname:@"27.147.149.178" port:9028];
    TBinaryProtocol *protocol  = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    thriftServiceChatTransportClient *server = [[thriftServiceChatTransportClient alloc] initWithProtocol:protocol];
    NSString *token = [server getToken:self.app.authCredential.accessToken];
    [server sendPicture:id token:token socketResponse:json bufferedByte:data fileName:name];
   // [server expireMyToken:self.app.authCredential.id token:token];
}

-(void) sendPrivatePhotoWithContactId:(int) id jsonString:(NSString*) json byteData:(NSData*) data filename:(NSString*) name
{
    TSocketClient *transport = [[TSocketClient alloc] initWithHostname:@"27.147.149.178" port:9028];
    TBinaryProtocol *protocol  = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    thriftServiceChatTransportClient *server = [[thriftServiceChatTransportClient alloc] initWithProtocol:protocol];
    NSString *token = [server getToken:self.app.authCredential.accessToken];
    [server sendPrivatePhoto:id token:token socketResponse:json bufferedByte:data fileName:name];
   // [server expireMyToken:self.app.authCredential.id token:token];
}

-(void) sendVoiceWithContactId:(int) id jsonString:(NSString*) json byteData:(NSData*) data filename:(NSString*) name
{
    TSocketClient *transport = [[TSocketClient alloc] initWithHostname:@"27.147.149.178" port:9028];
    TBinaryProtocol *protocol  = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    thriftServiceChatTransportClient *server = [[thriftServiceChatTransportClient alloc] initWithProtocol:protocol];
    NSString *token = [server getToken:self.app.authCredential.accessToken];
    [server sendVoice:id token:token socketResponse:json bufferedByte:data fileName:name];
   // [server expireMyToken:self.app.authCredential.id token:token];
}




- (void) authentication
{
    NSError* error;
    
    SocketResponse *response = [[SocketResponse alloc]init];
    
    SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
    
    responseStat.status = true;
    responseStat.tag = @"authentication";
    
    AppDelegate *app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    response.responseStat = responseStat;
    response.responseData = app.authCredential;
    
    NSLog(@"%@",response);
    
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
    
    [_chatSocket sendMessage:jsonString];
    
    NSLog(@"%@", jsonString);
    
    
    
}

-(void) scheduleNotificationForAlertBody:(NSString *)alertBody ActionButtonTitle:(NSString *)actionButtonTitle NotificationID:(NSString *)notificationID contacNo:(NSString*) contacNo msgBody:(NSString*) msgBody{
    
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotification.alertBody = alertBody;
    localNotification.alertAction = actionButtonTitle;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    localNotification.soundName = UILocalNotificationDefaultSoundName;

    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:notificationID,@"id",contacNo,@"phone",msgBody,@"msg",nil];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (tcpSocketChat*) getSocket
{
    return _chatSocket;
}

- (void) setTabBarItem:(UITabBarItem*) item
{
    _item = item;
}

- (void) setChatTable:(UITableView*) chatData
{
    _chatData = chatData;
}

- (void) emptyBadge
{
    self.badgeValue = 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        [[UIApplication sharedApplication] cancelLocalNotification:someNotification];
    }
   
    
     [_item setBadgeValue:nil];
}

- (void) setBadge
{
    [self scheduleNotificationForAlertBody:@"You have a new message" ActionButtonTitle:@"New" NotificationID:[self uuid] contacNo:@"" msgBody:@""];
    [_item setBadgeValue:[NSString stringWithFormat:@"%d",self.badgeValue]];
}

#pragma mark - tcpSocketDelegate
-(void)receivedMessage:(NSString *)data
{
    
    NSError* err = nil;
    SocketResponse *response = [[SocketResponse alloc] initWithString:data error:&err];
     NSLog(@"CHST RECD");
    
    if([response.responseStat.tag isEqualToString:@"textchat"])
    {
       
    }
}

-(NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}




@end
