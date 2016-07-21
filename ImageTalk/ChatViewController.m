//
//  ChatViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "ChatViewController.h"
#import "SenderTableViewCell.h"
#import "ReceiverTableViewCell.h"
#import "TextChat.h"
#import "Acknowledgement.h"
#import "SocketResponse.h"
#import "SocketTextResponse.h"
#import "UIImageView+WebCache.h"
#import "FriendsProfileViewController.h"
#import "JSONHTTPClient.h"
#import "ApiAccess.h"
#import "OnlineResponse.h"
#import "AcknowledgementResponse.h"
#import "ChatPhoto.h"
#import "SocketPhotoResponse.h"
#import "SenderImageTableViewCell.h"
#import "ReceiverImageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+RJLoader.h"
#import "ChatDetailsViewController.h"
#import "SenderLocationTableViewCell.h"
#import "ReceiverLocationTableViewCell.h"
#import "SenderContactsTableViewCell.h"
#import "ReceiverContactsTableViewCell.h"
#import "ShareLocationViewController.h"
#import "SocketLocationResponse.h"
#import "SocketContactResponse.h"
#import "ChatContact.h"
#import "PrivatePhotoViewController.h"
#import "ToastView.h"
#import "NSOutputStream+NSOutputStream_NS.h"
#import "SenderSingleTableViewCell.h"
#import "ReceiverSingleTableViewCell.h"
#import "NotificationTableViewCell.h"
#import "SocektAccess.h"
#import "SenderVideoTableViewCell.h"
#import "ReceiverVideoTableViewCell.h"
#import "SocketVideoResponse.h"
#import "NSDate+NVTimeAgo.h"
#import "UIImage+BlurredFrame.h"
#import "Date.h"
#import "DateTableViewCell.h"
#import "QBPlasticPopupMenu.h"

@interface ChatViewController ()
@property (assign,nonatomic) BOOL checkecdFirst;
@property (nonatomic, strong) QBPlasticPopupMenu *plasticPopupMenu;
@property (nonatomic,strong) Chat *selectedChat;
@end

@implementation ChatViewController
@synthesize type = _type;
@synthesize tableData = tableData;
@synthesize chatSocket = _chatSocket;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedChat = [[Chat alloc] init];
    self.title = [NSString stringWithFormat:@"%@ %@",self.contact.user.firstName,self.contact.user.lastName];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 200, 44);
    UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = NO;
    
    CGRect titleFrame = CGRectMake(0, 2, 200, 24);
    UILabel *titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"Arcitectura" size:26.0f];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    titleView.text =[NSString stringWithFormat:@"%@ %@",self.contact.user.firstName,self.contact.user.lastName];
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    
    CGRect subtitleFrame = CGRectMake(0, 24, 200, 44-24);
    _subtitleView = [[UILabel alloc] initWithFrame:subtitleFrame];
    _subtitleView.backgroundColor = [UIColor clearColor];
    _subtitleView.font = [UIFont boldSystemFontOfSize:11];
    _subtitleView.textAlignment = NSTextAlignmentCenter;
    _subtitleView.textColor = [UIColor whiteColor];
    _subtitleView.text = @"....";
    _subtitleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:_subtitleView];
    
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    socketurl = [defaults objectForKey:@"socketurl"];
    port = [defaults objectForKey:@"port"];
    
    self.profilePic.layer.cornerRadius = 16;
    [self.profilePic.layer setMasksToBounds:YES];
    
    [self.profilePic.imageView sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,self.contact.user.picPath.original.path]]
                                 placeholderImage:nil];
    
    [self.profilePic setImage:self.profilePic.imageView.image forState:UIControlStateNormal];
    
    self.chatTextView.layer.cornerRadius = 5.0;
    [self.chatTextView.layer setMasksToBounds:YES];
    
    self.chatTextView.frame = CGRectInset(self.chatTextView.frame, -1.0f, -1.0f);
    self.chatTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.chatTextView.layer.borderWidth = 1.0f;
    
    
    self.privateView.layer.cornerRadius = 5.0;
    [self.privateView.layer setMasksToBounds:YES];
    
    self.privateView.frame = CGRectInset(self.privateView.frame, -1.0f, -1.0f);
    self.privateView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.privateView.layer.borderWidth = 1.0f;
    
    self.photoView.layer.cornerRadius = 5.0;
    [self.photoView.layer setMasksToBounds:YES];
    
    self.photoView.frame = CGRectInset(self.photoView.frame, -1.0f, -1.0f);
    self.photoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.photoView.layer.borderWidth = 1.0f;
    
    self.videoView.layer.cornerRadius = 5.0;
    [self.videoView.layer setMasksToBounds:YES];
    
    self.videoView.frame = CGRectInset(self.photoView.frame, -1.0f, -1.0f);
    self.videoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.videoView.layer.borderWidth = 1.0f;
    
    self.myLocationView.layer.cornerRadius = 5.0;
    [self.myLocationView.layer setMasksToBounds:YES];
    
    self.myLocationView.frame = CGRectInset(self.myLocationView.frame, -1.0f, -1.0f);
    self.myLocationView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.myLocationView.layer.borderWidth = 1.0f;
    
    self.contactsView.layer.cornerRadius = 5.0;
    [self.contactsView.layer setMasksToBounds:YES];
    
    self.contactsView.frame = CGRectInset(self.contactsView.frame, -1.0f, -1.0f);
    self.contactsView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contactsView.layer.borderWidth = 1.0f;
    
    self.cancelView.layer.cornerRadius = 5.0;
    [self.cancelView.layer setMasksToBounds:YES];
    
    self.cancelView.frame = CGRectInset(self.cancelView.frame, -1.0f, -1.0f);
    self.cancelView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cancelView.layer.borderWidth = 1.0f;
    
    self.type.delegate = self;
    self.type.text = @"Type your message";
    self.type.textColor = [UIColor lightGrayColor];
    
    self.cImages = [[NSMutableDictionary alloc]init];
    
    
    self.isSend = false;
    
    
    self.app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.myObject = [[NSMutableArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableData addSubview:self.refreshControl];
    
    self.offset = 0;
    self.loaded = false;
    [self getData:self.offset];
    
    QBPopupMenuItem *item5 =  [QBPopupMenuItem itemWithTitle:@"Copy" target:self action:@selector(copyMessageAction )];
    QBPopupMenuItem *item6 = [QBPopupMenuItem itemWithTitle:@"Delete"  target:self action:@selector(deleteMessageAction)];
    NSArray *items = @[item5, item6];
    QBPlasticPopupMenu *plasticPopupMenu = [[QBPlasticPopupMenu alloc] initWithItems:items];
    plasticPopupMenu.height = 40;
    self.plasticPopupMenu = plasticPopupMenu;
}
-(void) copyMessageAction{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.selectedChat.chatText;
}
-(void) deleteMessageAction{
    NSDictionary *inventory = @{
                                @"chat_id" : self.selectedChat.chatId
                                };
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/user/chat/delete" params:inventory tag:@"deleteChatData"];
}

-(void)onLongPress:(UILongPressGestureRecognizer*)pGesture
{
    if (pGesture.state == UIGestureRecognizerStateRecognized)
    {
        //Do something to tell the user!
    }
    if (pGesture.state == UIGestureRecognizerStateEnded)
    {
        //UITableView* tableView = (UITableView*)self.view;
        CGPoint touchPoint = [pGesture locationInView:self.view];
        NSIndexPath* row = [self.tableData indexPathForRowAtPoint:touchPoint];
        if (row != nil) {
            Chat *data = self.myObject[row.row];
            self.selectedChat = data;
            CGRect rect = CGRectMake(touchPoint.x-10,touchPoint.y-5,5.0, 5.0 );
            [self.plasticPopupMenu showInView:self.view targetRect:rect animated:YES];
        }
    }
}


- (void)refresh{
    
    if(self.isData && self.loaded)
    {
        
        self.loaded = false;
        [self getData:self.offset];
        
        
    }
    
    [self.refreshControl endRefreshing];
}



-(void) timerTickWithChatId:(NSString *)chatId interval:(int)interval
{
    
}

-(void) timerFinishWithChatId:(NSString *)chatId
{
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [self.view setNeedsDisplay];
    
    for (int i = 0; i < self.myObject.count; i++)
    {
        NSLog(@"inside");
        Chat *data = self.myObject[i];
        if([self.myObject[i] isKindOfClass:[Chat class]])
        {
        if (data.from == self.app.authCredential.id) //sender
        {
        if(data.type == 5)
        {
            NSLog(@"inside typo");
            self.privatePhoto.userInteractionEnabled = NO;
            
        }
        }
            
        }
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.actionPicker setHidden:YES];
    
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    [[TimerAccess getSharedInstance] setDelegate:self];
    
    [[[SocektAccess getSharedInstance]getSocket]setDelegate:self];
    [[[SocektAccess getSharedInstance]getSocket] reconnect];
    _chatSocket =[[SocektAccess getSharedInstance]getSocket];
    
    [self online];
    
    
    if (self.isPrivateDestroyed)
    {
        
        self.myObject = nil;
        self.myObject = [[NSMutableArray alloc] init];
        self.offset = 0;
        self.loaded = false;
        [self getData:self.offset];
        self.isPrivateDestroyed = false;
    }
    
    if(self.imageToSend && self.isPrivate)
    {
        
        
        
        ChatPhoto *data = [[ChatPhoto alloc]init];
        data.tmpChatId = [self uuid];
        data.caption = @"";
        data.appCredential = (AppCredential*)self.contact;
        data.send = true;
        data.recevice = false;
        data.createdDate = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        data.base64Img = [self imageToString:self.imageToSend];
        data.timer = self.timer;
        data.tookSnapShot = false;
        
        self.type.text = @"";
        
        [self.myObject addObject:data];
        
        NSError* error;
        
        SocketResponse *response = [[SocketResponse alloc]init];
        
        SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
        
        responseStat.status = true;
        responseStat.tag = @"chatprivatephoto_transfer";
        
        response.responseStat = responseStat;
        response.responseData = data;
        
        // NSData *byteData = UIImagePNGRepresentation(self.imageToSend);
        
        
        NSData *dataR = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
        NSString* jsonString = [[NSString alloc] initWithData:dataR encoding:NSUTF8StringEncoding];
        
        jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
        
        
        // [[SocektAccess getSharedInstance] sendPrivatePhotoWithContactId:self.contact.id jsonString:jsonString byteData:byteData filename:self.imageName];
        
        [self.chatSocket sendMessage:jsonString];
        
        
        self.imageToSend = nil;
        self.isPrivate = false;
        self.timer = 0;
        
        self.history = false;
        [self.tableData reloadData];
        
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
        [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    }
    
    if (self.placeToSend) {
        
        ChatLocation *data = [[ChatLocation alloc]init];
        data.tmpChatId = [self uuid];
        data.places = self.placeToSend;
        data.appCredential = self.contact;
        data.send = true;
        data.recevice = false;
        data.createdDate = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        
        self.type.text = @"";
        
        
        [self.myObject addObject:data];
        
        NSError* error;
        
        SocketResponse *response = [[SocketResponse alloc]init];
        
        SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
        
        responseStat.status = true;
        responseStat.tag = @"chatlocation_share";
        
        
        response.responseStat = responseStat;
        response.responseData = data;
        
        
        
        
        
        NSData *dataR = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
        NSString* jsonString = [[NSString alloc] initWithData:dataR encoding:NSUTF8StringEncoding];
        
        jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
        
        [self.chatSocket sendMessage:jsonString];
        
        
        
        
        self.history = false;
        [self.tableData reloadData];
        
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
        [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
        
        
        self.placeToSend = nil;
    }
    
    if (self.contactToSend) {
        
        
        ChatContact *data = [[ChatContact alloc]init];
        data.tmpChatId = [self uuid];
        data.contact = self.contactToSend;
        data.appCredential = self.contact;
        data.send = true;
        data.recevice = false;
        data.createdDate = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        
        self.type.text = @"";
        
        
        [self.myObject addObject:data];
        
        NSError* error;
        
        SocketResponse *response = [[SocketResponse alloc]init];
        
        SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
        
        responseStat.status = true;
        responseStat.tag = @"chatcontact_share";
        
        
        response.responseStat = responseStat;
        response.responseData = data;
        
        
        
        
        
        NSData *dataR = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
        NSString* jsonString = [[NSString alloc] initWithData:dataR encoding:NSUTF8StringEncoding];
        
        jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
        
        [self.chatSocket sendMessage:jsonString];
        
        
        
        self.history = false;
        [self.tableData reloadData];
        
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
        [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
        
        self.contactToSend = nil;
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.view endEditing:YES];
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self.actionPicker setHidden:YES];
    [self.send setImage:[UIImage imageNamed:@"comment-add"] forState:UIControlStateNormal];
    self.isSend = true;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Type your message"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"Type your message";
        textView.textColor = [UIColor lightGrayColor]; //optional
        [self.send setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
        self.isSend = false;
    }
}







- (IBAction)send:(id)sender
{
    if(self.isSend && ![self.type.text isEqual:@""])
    {
        TextChat *data = [[TextChat alloc]init];
        data.tmpChatId = [self uuid];
        
        NSData *textFieldUTF8Data = [self.type.text dataUsingEncoding: NSNonLossyASCIIStringEncoding];
        data.text =  [[NSString alloc] initWithData:textFieldUTF8Data encoding:NSUTF8StringEncoding];
        data.appCredential = self.contact;
        data.send = true;
        data.recevice = false;
        data.createdDate = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        
        
        
        
        TextChat *dataY = [[TextChat alloc]init];
        dataY.tmpChatId = [self uuid];
        
        
        dataY.text = self.type.text ;
        dataY.appCredential = self.contact;
        dataY.send = true;
        dataY.recevice = false;
        dataY.createdDate = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        
        self.type.text = @"";
        
        [self.myObject addObject:dataY];
        
        NSError* error;
        
        SocketResponse *response = [[SocketResponse alloc]init];
        
        SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
        
        responseStat.status = true;
        responseStat.tag = @"textchat";
        
        
        response.responseStat = responseStat;
        response.responseData = data;
        
        
        
        
        NSData *dataR = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
        NSString* jsonString = [[NSString alloc] initWithData:dataR encoding:NSUTF8StringEncoding];
        
        jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
        [self.chatSocket sendMessage:jsonString];
        
        
        
        self.history = false;
        [self.tableData reloadData];
        
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
        [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
    }
    
    [self.view endEditing:YES];
    
}



- (NSData*) convertToJavaUTF8 : (NSString*) str {
    NSUInteger len = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    Byte buffer[2];
    buffer[0] = (0xff & (len >> 8));
    buffer[1] = (0xff & len);
    NSMutableData *outData = [NSMutableData dataWithCapacity:2];
    [outData appendBytes:buffer length:2];
    [outData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    return outData;
}

-(void) getData:(int) offset{
    
    
    NSDictionary *inventory = @{@"offset" : [NSString stringWithFormat:@"%d",offset],
                                @"to" : [NSString stringWithFormat:@"%d",self.contact.id],
                                @"limit" : @"56"
                                };
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/user/chat/show" params:inventory tag:@"getChatData"];
    
}



- (void) online
{
    NSError* error;
    
    OnlineResponse *response = [[OnlineResponse alloc]init];
    
    SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
    
    responseStat.status = true;
    responseStat.tag = @"user_online";
    
    
    response.responseStat = responseStat;
    response.responseData = [NSArray arrayWithObject:[NSNumber numberWithInteger:self.contact.id]];
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
    
    [self.chatSocket sendMessage:jsonString];
    
}

- (void) acknowledgementWithChatid: (NSString*) chatId appCredential:(AppCredential *) appCredential
{
    NSError* error;
    
    SocketResponse *response = [[SocketResponse alloc]init];
    SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
    
    responseStat.status = true;
    responseStat.tag = @"chat_acknowledgement";
    
    Acknowledgement *responseData = [[Acknowledgement alloc]init];
    
    responseData.chatId = chatId;
    responseData.appCredential = appCredential;
    responseData.isOnline = true;
    responseData.isRead = true;
    
    response.responseStat = responseStat;
    response.responseData = responseData;
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
    
    [self.chatSocket sendMessage:jsonString];
    
    
}





-(void)keyboardDidHide:(NSNotification *)notification
{
    
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    self.view.frame = newFrame;
    [UIView commitAnimations];
}

-(void)keyboardDidShow:(NSNotification *)notification
{
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    self.view.frame = newFrame;
    [UIView commitAnimations];
}

- (void)showLoginView{
    
    self.actionPicker.hidden = NO;
}
- (IBAction)showContacts:(id)sender {
    
    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [_addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:_addressBookController animated:YES completion:nil];
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}



- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    
    CFStringRef firstName = (CFStringRef)ABRecordCopyValue(person,kABPersonFirstNameProperty);
    CFStringRef lastName = (CFStringRef)ABRecordCopyValue(person,kABPersonLastNameProperty);
    NSString *phone = [[NSString alloc]init];
    BOOL isExist = false;
    
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    for(CFIndex i=0; i<ABMultiValueGetCount(multiPhones); i++) {
        @autoreleasepool {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
            NSString *phoneNumber = CFBridgingRelease(phoneNumberRef);
            if (phoneNumber != nil){
                phone = phoneNumber;
                
            }
        }
    }
    
    Contact *contact = [[Contact alloc]init];
    
    
    for (int i=0;i<self.app.contacts.count;i++)
    {
        Contact *test = self.app.contacts[i];
        
        if ([test.phoneNumber isEqualToString:phone])
        {
            contact = test;
            isExist = true;
            break;
        }
        
        
    }
    
    
    if (!isExist)
    {
        User *user = [[User alloc]init];
        user.id = 0;
        user.firstName = [(__bridge NSString*)firstName copy];
        user.lastName = [(__bridge NSString*)lastName copy];
        
        user.firstName = (user.firstName) ? user.firstName : @" ";
        user.lastName = (user.lastName) ? user.lastName : @" ";
        
        contact.id = 0;
        contact.user = user;
        contact.phoneNumber = phone;
    }
    
    
    
    ChatContact *data = [[ChatContact alloc]init];
    data.tmpChatId = [self uuid];
    data.contact = contact;
    data.appCredential = self.contact;
    data.send = true;
    data.recevice = false;
    data.createdDate = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    self.type.text = @"";
    
    
    [self.myObject addObject:data];
    
    NSError* error;
    
    SocketResponse *response = [[SocketResponse alloc]init];
    
    SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
    
    responseStat.status = true;
    responseStat.tag = @"chatcontact_share";
    
    
    response.responseStat = responseStat;
    response.responseData = data;
    
    
    
    
    
    NSData *dataR = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonString = [[NSString alloc] initWithData:dataR encoding:NSUTF8StringEncoding];
    
    jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
    
    [self.chatSocket sendMessage:jsonString];
    
    
    
    self.history = false;
    [self.tableData reloadData];
    
    NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
    [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
    
    self.contactToSend = nil;
    
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}


- (void)hideLoginView{
    
    self.actionPicker.hidden = YES;
}
- (IBAction)privatePhoto:(id)sender
{
    [self hideLoginView];
    self.isPrivate = true;
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)video:(id)sender {
    
    self.isVideo = true;
    [self hideLoginView];
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}

- (IBAction)photoVideo:(id)sender {
    
    [self hideLoginView];
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}

- (IBAction)cancel:(id)sender {
    
    [self hideLoginView];
}


- (IBAction)addStuff:(id)sender {
    
    [self.view endEditing:YES];
    [self showLoginView];
    
}



- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self hideLoginView];
    [self.type resignFirstResponder];
}

#pragma mark - table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myObject.count;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)widthOfString:(NSString *)string withFont:(NSFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     
    if([self.myObject[indexPath.row] isKindOfClass:[Chat class]])
    {
        
        Chat *data = self.myObject[indexPath.row];
        NSLog(@"chatdata: %@",data);
        
        CGSize stringSize = [data.chatText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
        
        
        
        if (data.from == self.app.authCredential.id) //sender
        {
            
            if(data.type == 0) // Text
            {
                if (stringSize.width + 100 > self.view.frame.size.width) {
                    
                    SenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Sender" forIndexPath:indexPath];
                    
                    if (cell == nil) {
                        cell=[[SenderTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Sender"];
                    }else{
                        cell.text.text =nil;
                        cell.time.text = nil;
                        cell.check.image = nil;
                    }
                    
                    NSData *strData = [data.chatText dataUsingEncoding:NSUTF8StringEncoding];
                    cell.text.text = [[NSString alloc] initWithData:strData encoding:NSNonLossyASCIIStringEncoding];
                    
                    
                    
                    NSTimeInterval timestamp = [data.createdDate longLongValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    
                    cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                    cell.check.image = (data.readStatus) ? [UIImage imageNamed:@"seen"]:[UIImage imageNamed:@"unseen"];
                    
                    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
                    [cell addGestureRecognizer:longPressRecognizer];
                    
                    return cell;
                }
                else
                {
                    SenderSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderSingle" forIndexPath:indexPath];
                    
                    if (cell == nil) {
                        cell=[[SenderSingleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Sender"];
                    }else{
                        cell.text.text =nil;
                        cell.time.text = nil;
                        cell.check.image = nil;
                    }
                    
                    NSData *strData = [data.chatText dataUsingEncoding:NSUTF8StringEncoding];
                    cell.text.text = [[NSString alloc] initWithData:strData encoding:NSNonLossyASCIIStringEncoding];
                    
                    //cell.text.text = data.chatText;
                    
                    
                    NSTimeInterval timestamp = [data.createdDate longLongValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    
                    cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                    cell.check.image = (data.readStatus) ? [UIImage imageNamed:@"seen"]:[UIImage imageNamed:@"unseen"];
                    
                    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
                    [cell addGestureRecognizer:longPressRecognizer];
                    
                    return cell;
                }
                
            }
            else if (data.type == 3) //Location
            {
                SenderLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderLocation" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[SenderLocationTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SenderLocation"];
                }else{
                    cell.title.text = nil;
                    cell.subtitle.text = nil;
                    cell.check.image = nil;
                    cell.click.tag = 0;
                    cell.time.text = nil;
                }
                
                
                ChatExtra *places = (ChatExtra*) data.extra;
                
                cell.title.text = places.name;
                cell.subtitle.text = places.formattedAddress;
                cell.check.image = (data.readStatus) ? [UIImage imageNamed:@"seen"]:[UIImage imageNamed:@"unseen"];
                
                NSString *staticMapUrl = [NSMutableString stringWithFormat:@"https://api.mapbox.com/v4/mapbox.streets/pin-m-marker+482(%f,%f)/%f,%f,14/%dx%d.png?access_token=pk.eyJ1Ijoic2lhbWJpc3dhcyIsImEiOiJjaWhvZGgyZjcwYmVvdTJqN3NqOWk4OTRhIn0.XM1iQVkiGP3KtSdESq0ErQ",places.lng,places.lat,places.lng,places.lat,(int)cell.image.frame.size.width,(int)cell.image.frame.size.height];
                
                NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                // [cell.image sd_setImageWithURL:mapUrl placeholderImage:nil];
                
                NSData *imageData = [NSData dataWithContentsOfURL:mapUrl];
                cell.image.image = [UIImage imageWithData:imageData];
                
                NSTimeInterval timestamp = [data.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                cell.click.tag = indexPath.row;
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                return cell;
            }
            else if (data.type == 4) //Contact
            {
                SenderContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderContact" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[SenderContactsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SenderContact"];
                }else{
                    
                    cell.title.text = nil;
                    cell.check.image = nil;
                    cell.click.tag = 0;
                    cell.messageClick.tag = 0;
                    cell.time.text = nil;
                    
                }
                
                
                cell.title.text = [NSString stringWithFormat:@"%@ %@",data.extra.user.firstName,data.extra.user.lastName];
                cell.check.image = (data.readStatus) ? [UIImage imageNamed:@"seen"]:[UIImage imageNamed:@"unseen"];
                Picture *picture = data.extra.user.picPath;
                
                [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,picture.original.path]]
                              placeholderImage:nil];
                
                NSTimeInterval timestamp = [data.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                [cell.messageClick setTitle:(data.extra.id == 0)?@"Invite to ImageTalk":@"Message" forState:UIControlStateNormal];
                cell.click.tag = indexPath.row;
                cell.messageClick.tag = indexPath.row;
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                return cell;
            }
            else if (data.type == 6)// Copied private photo
            {
                NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Notification" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[NotificationTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Notification"];
                }else{
                    cell.time.text = nil;
                    cell.text.text = nil;
                }
                
                cell.text.text = [NSString stringWithFormat:@"%@ copied your photo",self.contact.user.firstName];
                
                
                NSTimeInterval timestamp = [data.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                return cell;
            }
            else if (data.type == 2)//VideoFile
            {
                SenderVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderVideo" forIndexPath:indexPath];
                
                if (cell == nil) {
                    
                    cell=[[SenderVideoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SenderVideo"];
                }
                else{
                    cell.check.image =nil;
                    cell.time.text = nil;
                    cell.click.tag = 0;
                    cell.image.image = nil;
                }
                
                cell.check.image = (data.readStatus) ? [UIImage imageNamed:@"seen"]:[UIImage imageNamed:@"unseen"];
                
                
                NSTimeInterval timestamp = [data.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                
                cell.click.tag = indexPath.row;
                [cell.click addTarget:self action:@selector(playVideoFromHistory:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@app/transfer/file?v=%@",baseurl,data.mediaPath.path]];
                // cell.image.image = [self thumbnailImageForVideo:url atTime:0];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [cell.image startLoaderWithTintColor:[UIColor orangeColor]];
                    __weak typeof(cell)weakSelf = cell;
                    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.mediaPath.coverPic]] placeholderImage:nil options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        [weakSelf.image updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [weakSelf.image reveal];
                    }];
                    
                    
                }];
                
                return cell;
            }
            else
            {
                SenderImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderImage" forIndexPath:indexPath];
                
                if (cell == nil) {
                    
                    cell=[[SenderImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SenderImage"];
                }
                else{
                    cell.check.image =nil;
                    cell.time.text = nil;
                    cell.click.tag = 0;
                    cell.image.image = nil;
                }
                
                NSTimeInterval timestamp = [data.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                
                Picture *picture = (Picture*) data.mediaPath;
                cell.check.image = (data.readStatus) ? [UIImage imageNamed:@"seen"]:[UIImage imageNamed:@"unseen"];
                cell.click.tag = indexPath.row;
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                /*   [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,picture.original.path]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                 
                 cell.imageValue = cell.image.image;
                 ChatPhoto *photo = (ChatPhoto*) data.extra;
                 
                 if (data.type==5) {
                 
                 
                 cell.timerValue = photo.timer;
                 [cell.click setImage:[UIImage imageNamed:@"key-1"] forState:UIControlStateNormal];
                 [cell.image setImage:[cell.image.image applyLightEffectAtFrame:CGRectMake(0,0,cell.image.image.size.width,cell.image.image.size.height)]];
                 
                 }
                 else
                 {
                 [cell.click setImage:nil forState:UIControlStateNormal];
                 }
                 }];*/
                
                /* */
                
                
                
                
                
                
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [cell.image startLoaderWithTintColor:[UIColor orangeColor]];
                    __weak typeof(cell)weakSelf = cell;
                    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,picture.original.path]] placeholderImage:nil options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        [weakSelf.image updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [weakSelf.image reveal];
                        
                        cell.imageValue = cell.image.image;
                        ChatPhoto *photo = (ChatPhoto*) data.extra;
                        
                        if (data.type==5) //Private photo
                        {
                            
                            
                            cell.timerValue = photo.timer;
                            [cell.click setImage:[UIImage imageNamed:@"key-1"] forState:UIControlStateNormal];
                            cell.effect.hidden = false;
                            
                        }
                        else
                        {
                            cell.effect.hidden = true;
                            [cell.click setImage:nil forState:UIControlStateNormal];
                        }
                        
                        
                    }];
                    
                    
                }];
                
                
                
                
                
                
                
                
                return cell;
            }
        }
        else //receiver
        {
            //textChat = 0 , PhotoChat = 1,  VideoFile = 2 , Location = 3, Contact = 4 , Private photo = 5
            
            if(data.type == 0)
            {
                if (stringSize.width + 100 > self.view.frame.size.width) {
                    
                    ReceiverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Receiver" forIndexPath:indexPath];
                    
                    if (cell == nil) {
                        cell=[[ReceiverTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Receiver"];
                    }else{
                        cell.text.text = nil;
                        cell.time.text = nil;
                    }
                    NSData *strData = [data.chatText dataUsingEncoding:NSUTF8StringEncoding];
                    cell.text.text = [[NSString alloc] initWithData:strData encoding:NSNonLossyASCIIStringEncoding];
                    
                    //cell.text.text = data.chatText;
                    
                    
                    NSTimeInterval timestamp = [data.createdDate longLongValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    
                    cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                    
                    if (!data.readStatus) {
                        [self acknowledgementWithChatid:data.chatId appCredential:self.contact];
                    }
                    
                    return cell;
                }
                else
                {
                    ReceiverSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverSingle" forIndexPath:indexPath];
                    
                    if (cell == nil) {
                        cell=[[ReceiverSingleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Receiver"];
                    }
                    else{
                        cell.text.text = nil;
                        cell.time.text = nil;
                    }
                    NSData *strData = [data.chatText dataUsingEncoding:NSUTF8StringEncoding];
                    cell.text.text = [[NSString alloc] initWithData:strData encoding:NSNonLossyASCIIStringEncoding];
                    //cell.text.text = data.chatText;
                    
                    
                    NSTimeInterval timestamp = [data.createdDate longLongValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    
                    cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                    
                    if (!data.readStatus) {
                        [self acknowledgementWithChatid:data.chatId appCredential:self.contact];
                    }
                    
                    return cell;
                }
                
                
            }
            else if(data.type == 3)
            {
                ReceiverLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverLocation" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[ReceiverLocationTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ReceiverLocation"];
                }else{
                    cell.title.text = nil;
                    cell.subtitle.text = nil;
                    cell.time.text = nil;
                    cell.image.image = nil;
                    cell.click.tag = 0;
                }
                
                ChatExtra *places = (ChatExtra*) data.extra;
                
                cell.title.text = places.name;
                cell.subtitle.text = places.formattedAddress;
                
                NSString *staticMapUrl = [NSMutableString stringWithFormat:@"https://api.mapbox.com/v4/mapbox.streets/pin-m-marker+482(%f,%f)/%f,%f,14/%dx%d.png?access_token=pk.eyJ1Ijoic2lhbWJpc3dhcyIsImEiOiJjaWhvZGgyZjcwYmVvdTJqN3NqOWk4OTRhIn0.XM1iQVkiGP3KtSdESq0ErQ",places.lng,places.lat,places.lng,places.lat,(int)cell.image.frame.size.width,(int)cell.image.frame.size.height];
                
                NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                //[cell.image sd_setImageWithURL:mapUrl placeholderImage:nil];
                
                NSData *imageData = [NSData dataWithContentsOfURL:mapUrl];
                cell.image.image = [UIImage imageWithData:imageData];
                
                NSTimeInterval timestamp = [data.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                cell.click.tag = indexPath.row;
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                if (!data.readStatus)
                {
                    [self acknowledgementWithChatid:data.chatId appCredential:self.contact];
                }
                
                return cell;
            }
            else if(data.type == 4)
            {
                ReceiverContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverContact" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[ReceiverContactsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ReceiverContact"];
                }else{
                    cell.title.text = nil;
                    
                    cell.time.text = nil;
                    cell.image.image = nil;
                    cell.click.tag = 0;
                }
                
                cell.title.text = [NSString stringWithFormat:@"%@ %@",data.extra.user.firstName,data.extra.user.lastName];
                Picture *picture = data.extra.user.picPath;
                
                [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,picture.original.path]]
                              placeholderImage:nil];
                
                NSTimeInterval timestamp = [data.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                [cell.messageClick setTitle:(data.extra.id == 0)?@"Invite to ImageTalk":@"Message" forState:UIControlStateNormal];
                cell.click.tag = indexPath.row;
                cell.messageClick.tag = indexPath.row;
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                
                if (!data.readStatus) {
                    [self acknowledgementWithChatid:data.chatId appCredential:self.contact];
                }
                
                return cell;
            }
            else if (data.type == 6)
            {
                NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Notification" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[NotificationTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Notification"];
                }else{
                    cell.text.text = nil;
                    cell.time.text = nil;
                }
                
                cell.text.text = @"Notified user about your action";
                
                
                NSTimeInterval timestamp = [data.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                return cell;
            }
            else if (data.type == 2)
            {
                ReceiverVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverVideo" forIndexPath:indexPath];
                
                if (cell == nil) {
                    
                    cell=[[ReceiverVideoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ReceiverVideo"];
                }else{
                    cell.click.tag =0;
                    cell.image.image = nil;
                    cell.time.text = nil;
                }
                
                
                
                NSTimeInterval timestamp = [data.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                cell.click.tag = indexPath.row;
                [cell.click addTarget:self action:@selector(playVideoFromHistory:) forControlEvents:UIControlEventTouchUpInside];
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [cell.image startLoaderWithTintColor:[UIColor orangeColor]];
                    __weak typeof(cell)weakSelf = cell;
                    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.mediaPath.coverPic]] placeholderImage:nil options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        [weakSelf.image updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [weakSelf.image reveal];
                    }];
                    
                    
                }];
                
                if (!data.readStatus) {
                    [self acknowledgementWithChatid:data.chatId appCredential:self.contact];
                }
                
                return cell;
            }
            else
            {
                ReceiverImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverImage" forIndexPath:indexPath];
                
                if (cell == nil) {
                    
                    cell=[[ReceiverImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ReceiverImage"];
                }else{
                    cell.click.tag =0;
                    cell.image.image = nil;
                    cell.time.text = nil;
                }
                
                
                Picture *picture = (Picture*) data.mediaPath;
                
                
                
                
                
                
                
                
                NSTimeInterval timestamp = [data.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                cell.click.tag = indexPath.row;
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [cell.image startLoaderWithTintColor:[UIColor orangeColor]];
                    __weak typeof(cell)weakSelf = cell;
                    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,picture.original.path]] placeholderImage:nil options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        [weakSelf.image updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [weakSelf.image reveal];
                        cell.imageValue = cell.image.image;
                        ChatPhoto *photo = (ChatPhoto*) data.extra;
                        
                        if (data.type==5) {
                            
                            cell.timerValue = photo.timer;
                            [cell.click setImage:[UIImage imageNamed:@"key-1"] forState:UIControlStateNormal];
                            cell.effect.hidden = false;
                            
                        }
                        else
                        {
                            [cell.click setImage:nil forState:UIControlStateNormal];
                            cell.effect.hidden = true;
                        }
                        
                        
                        
                    }];
                    
                    
                }];
                
                
                
                if (!data.readStatus) {
                    [self acknowledgementWithChatid:data.chatId appCredential:self.contact];
                }
                
                return cell;
            }
            
        }
    }
    else if([self.myObject[indexPath.row] isKindOfClass:[ChatPhoto class]])
    {
        
        ChatPhoto *dataT = self.myObject[indexPath.row];
        
        if (dataT.extra)
        {
            if (dataT.send)
            {
                NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Notification" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[NotificationTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Notification"];
                }
                else{
                    cell.text.text = nil;
                    cell.time.text = nil;
                }
                
                cell.text.text = @"Notified user about your action";
                
                
                NSTimeInterval timestamp = [dataT.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                return cell;
                
            }
            
            if (dataT.recevice)
            {
                NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Notification" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[NotificationTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Notification"];
                }else{
                    cell.text.text = nil;
                    cell.time.text = nil;
                }
                
                cell.text.text = [NSString stringWithFormat:@"%@ copied your photo",self.contact.user.firstName];
                
                
                NSTimeInterval timestamp = [dataT.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                return cell;
            }
        }
        else
        {
            
            if (dataT.send)
            {
                SenderImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderImage" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[SenderImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SenderImage"];
                }else{
                    cell.click.tag = 0;
                    
                    cell.time.text = nil;
                    cell.check.image = nil;
                    cell.image.image = nil;
                    cell.imageValue = nil;
                    
                }
                
                NSTimeInterval timestamp = [dataT.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                cell.click.tag = indexPath.row;
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                cell.check.image =[UIImage imageNamed:@"unseen"];
                cell.image.image = [self stringToImage:dataT.base64Img];
                cell.imageValue = cell.image.image;
                
                if (dataT.timer)
                {
                    cell.timerValue = dataT.timer;
                    [cell.click setImage:[UIImage imageNamed:@"key-1"] forState:UIControlStateNormal];
                    //[cell.image setImage:[cell.image.image applyLightEffectAtFrame:cell.image.frame]];
                    cell.effect.hidden = false;
                }
                else
                {
                    [cell.click setImage:nil forState:UIControlStateNormal];
                    cell.effect.hidden = true;
                }
                
                
                return cell;
            }
            
            
            if (dataT.recevice) {
                ReceiverImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverImage" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[ReceiverImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ReceiverImage"];
                }else{
                    cell.click.tag = 0;
                    
                    cell.time.text = nil;
                   
                    cell.image.image = nil;
                    cell.imageValue = nil;
                    
                }
                
                Picture *picture = dataT.pictures;
                NSTimeInterval timestamp = [dataT.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                cell.click.tag = indexPath.row;
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [cell.image startLoaderWithTintColor:[UIColor orangeColor]];
                    __weak typeof(cell)weakSelf = cell;
                    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,picture.original.path]] placeholderImage:nil options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        [weakSelf.image updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [weakSelf.image reveal];
                        
                        cell.imageValue = cell.image.image;
                        
                        if (dataT.timer) {
                            cell.timerValue = dataT.timer;
                            [cell.click setImage:[UIImage imageNamed:@"key-1"] forState:UIControlStateNormal];
                            // [cell.image setImage:[cell.image.image applyLightEffectAtFrame:cell.image.frame]];
                            cell.effect.hidden = false;
                        }
                        else
                        {
                            cell.effect.hidden = true;
                            [cell.click setImage:nil forState:UIControlStateNormal];
                        }
                        
                    }];
                    
                    
                }];
                
                
                return cell;
            }
        }
        
    }
    else if([self.myObject[indexPath.row] isKindOfClass:[ChatVideo class]])
    {
        
        ChatVideo *dataT = self.myObject[indexPath.row];
        
        
        if (dataT.send)
        {
            SenderVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderVideo" forIndexPath:indexPath];
            
            if (cell == nil) {
                cell=[[SenderVideoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SenderVideo"];
            }else{
                cell.click.tag = 0;
                
                cell.time.text = nil;
                
                cell.image.image = nil;
                cell.check.image = nil;
                
            }
            
            NSTimeInterval timestamp = [dataT.createdDate longLongValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
            
            cell.click.tag = indexPath.row;
            cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
            cell.check.image =[UIImage imageNamed:@"unseen"];
            
            [cell.click addTarget:self action:@selector(playVideoSelf:) forControlEvents:UIControlEventTouchUpInside];
            
            NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",dataT.video.path]];
            cell.image.image = [self thumbnailImageForVideo:url atTime:0];
            
            return cell;
        }
        
        
        if (dataT.recevice) {
            ReceiverVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverVideo" forIndexPath:indexPath];
            
            if (cell == nil) {
                cell=[[ReceiverVideoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ReceiverVideo"];
            }
            
            NSTimeInterval timestamp = [dataT.createdDate longLongValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
            
            cell.click.tag = indexPath.row;
            cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
            [cell.click addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
            
            // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@app/transfer/file?v=%@",baseurl,dataT.video.path]];
            //cell.image.image = [self thumbnailImageForVideo:url atTime:0];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [cell.image startLoaderWithTintColor:[UIColor orangeColor]];
                __weak typeof(cell)weakSelf = cell;
                [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,dataT.video.coverPic]] placeholderImage:nil options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    [weakSelf.image updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [weakSelf.image reveal];
                }];
                
                
            }];
            
            return cell;
        }
        
    }
    else if([self.myObject[indexPath.row] isKindOfClass:[ChatLocation class]])
    {
        
        ChatLocation *dataT = self.myObject[indexPath.row];
        
        if (dataT.send) {
            SenderLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderLocation" forIndexPath:indexPath];
            
            if (cell == nil) {
                cell=[[SenderLocationTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SenderLocation"];
            }
            
            
            cell.title.text = dataT.places.name;
            cell.subtitle.text = dataT.places.formattedAddress;
            cell.check.image =[UIImage imageNamed:@"unseen"];
            
            
            NSString *staticMapUrl = [NSMutableString stringWithFormat:@"https://api.mapbox.com/v4/mapbox.streets/pin-m-marker+482(%f,%f)/%f,%f,14/%dx%d.png?access_token=pk.eyJ1Ijoic2lhbWJpc3dhcyIsImEiOiJjaWhvZGgyZjcwYmVvdTJqN3NqOWk4OTRhIn0.XM1iQVkiGP3KtSdESq0ErQ",dataT.places.lng,dataT.places.lat,dataT.places.lng,dataT.places.lat,(int)cell.image.frame.size.width,(int)cell.image.frame.size.height];
            
            NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSData *imageData = [NSData dataWithContentsOfURL:mapUrl];
            cell.image.image = [UIImage imageWithData:imageData];
            
            
            NSTimeInterval timestamp = [dataT.createdDate longLongValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
            
            cell.click.tag = indexPath.row;
            cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
            
            return cell;
        }
        
        
        if (dataT.recevice) {
            ReceiverLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverLocation" forIndexPath:indexPath];
            
            if (cell == nil) {
                cell=[[ReceiverLocationTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ReceiverLocation"];
            }
            
            cell.title.text = dataT.places.name;
            cell.subtitle.text = dataT.places.formattedAddress;
            
            NSString *staticMapUrl = [NSMutableString stringWithFormat:@"https://api.mapbox.com/v4/mapbox.streets/pin-m-marker+482(%f,%f)/%f,%f,14/%dx%d.png?access_token=pk.eyJ1Ijoic2lhbWJpc3dhcyIsImEiOiJjaWhvZGgyZjcwYmVvdTJqN3NqOWk4OTRhIn0.XM1iQVkiGP3KtSdESq0ErQ",dataT.places.lng,dataT.places.lat,dataT.places.lng,dataT.places.lat,(int)cell.image.frame.size.width,(int)cell.image.frame.size.height];
            
            NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSData *imageData = [NSData dataWithContentsOfURL:mapUrl];
            cell.image.image = [UIImage imageWithData:imageData];
            
            
            NSTimeInterval timestamp = [dataT.createdDate longLongValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
            
            cell.click.tag = indexPath.row;
            cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
            
            return cell;
        }
        
    }
    else if([self.myObject[indexPath.row] isKindOfClass:[Date class]])
    {
        Date *date = self.myObject[indexPath.row];
        
        DateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Date" forIndexPath:indexPath];
        
        if (cell == nil) {
            cell=[[DateTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Date"];
        }
        
        cell.date.text = date.dateString;
        
        return cell;
    }
    else if([self.myObject[indexPath.row] isKindOfClass:[ChatContact class]])
    {
        
        ChatContact *dataT = self.myObject[indexPath.row];
        
        if (dataT.send) {
            SenderContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderContact" forIndexPath:indexPath];
            
            if (cell == nil) {
                cell=[[SenderContactsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SenderContact"];
            }
            
            
            cell.title.text = [NSString stringWithFormat:@"%@ %@",dataT.contact.user.firstName,dataT.contact.user.lastName];
            cell.check.image =[UIImage imageNamed:@"unseen"];
            Picture *picture = dataT.contact.user.picPath;
            
            [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,picture.original.path]]
                          placeholderImage:nil];
            
            NSTimeInterval timestamp = [dataT.createdDate longLongValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
            
            [cell.messageClick setTitle:(dataT.contact.id == 0)?@"Invite to ImageTalk":@"Message" forState:UIControlStateNormal];
            cell.click.tag = indexPath.row;
            cell.messageClick.tag = indexPath.row;
            cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
            
            return cell;
        }
        
        
        if (dataT.recevice) {
            ReceiverContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverContact" forIndexPath:indexPath];
            
            if (cell == nil) {
                cell=[[ReceiverContactsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ReceiverContact"];
            }
            
            cell.title.text = [NSString stringWithFormat:@"%@ %@",dataT.contact.user.firstName,dataT.contact.user.lastName];
            Picture *picture = dataT.contact.user.picPath;
            
            [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,picture.original.path]]
                          placeholderImage:nil];
            
            NSTimeInterval timestamp = [dataT.createdDate longLongValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
            
            [cell.messageClick setTitle:(dataT.contact.id == 0)?@"Invite to ImageTalk":@"Message" forState:UIControlStateNormal];
            cell.click.tag = indexPath.row;
            cell.messageClick.tag = indexPath.row;
            cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
            
            return cell;
        }
        
    }
    else
    {
        
        TextChat *dataT = self.myObject[indexPath.row];
        CGSize stringSize = [dataT.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
        
        if (dataT.send) {
            
            if (stringSize.width + 100 > self.view.frame.size.width) {
                
                SenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Sender" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[SenderTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Sender"];
                }
                
                cell.text.text = dataT.text;
                
                NSTimeInterval timestamp = [dataT.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                cell.check.image =[UIImage imageNamed:@"unseen"];
                
                
                return cell;
                
            }
            else
            {
                SenderSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderSingle" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[SenderSingleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Sender"];
                }
                
                cell.text.text = dataT.text;
                
                NSTimeInterval timestamp = [dataT.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                cell.check.image =[UIImage imageNamed:@"unseen"];
                
                
                return cell;
            }
            
            
        }
        
        
        if (dataT.recevice) {
            
            if (stringSize.width + 100 > self.view.frame.size.width) {
                
                ReceiverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Receiver" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[ReceiverTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Receiver"];
                }
                
                cell.text.text =  dataT.text;
                
                NSTimeInterval timestamp = [dataT.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                
                
                return cell;
            }
            else
            {
                ReceiverSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverSingle" forIndexPath:indexPath];
                
                if (cell == nil) {
                    cell=[[ReceiverSingleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ReceiverSingle"];
                }
                
                cell.text.text =  dataT.text;
                
                NSTimeInterval timestamp = [dataT.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
                
                
                
                return cell;
                
            }
        }
        
    }
    
    
    
    return nil;
    
}

- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL
                             atTime:(NSTimeInterval)time
{
    
    
    if (![self.cImages objectForKey:videoURL])
    {
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetIG =
        [[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetIG.appliesPreferredTrackTransform = YES;
        assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = time;
        NSError *igError = nil;
        thumbnailImageRef =
        [assetIG copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
                        actualTime:NULL
                             error:&igError];
        
        if (!thumbnailImageRef)
            NSLog(@"thumbnailImageGenerationError %@", igError );
        
        UIImage *thumbnailImage = thumbnailImageRef
        ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]
        : nil;
        
        if (thumbnailImage) {
            NSLog(@"SETETED");
            [self.cImages setObject:thumbnailImage forKey:videoURL];
        }
        
        return thumbnailImage;
        
    }
    else
    {
        return [self.cImages objectForKey:videoURL];
    }
    
    
}


-(void)playVideoFromHistory:(UIButton*)sender
{
    
    if([self.myObject[sender.tag] isKindOfClass:[ChatVideo class]])
    {
        ChatVideo *dataT = self.myObject[sender.tag];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@app/transfer/file?v=%@",baseurl,dataT.video.path]];
        
        MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlaybackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
        
        mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        
        [mpvc.moviePlayer setContentURL:url];
        
        [self presentMoviePlayerViewControllerAnimated:mpvc];
    }
    else
    {
        Chat *data = self.myObject[sender.tag];
        
        NSLog(@"VIDEO DATA : %@",data);
        
        VideoDetails *dataT = (VideoDetails*) data.mediaPath;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@app/transfer/file?v=%@",baseurl,dataT.path]];
        
        MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlaybackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
        
        mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        
        [mpvc.moviePlayer setContentURL:url];
        
        [self presentMoviePlayerViewControllerAnimated:mpvc];
    }
}

-(void)playVideo:(UIButton*)sender
{
    ChatVideo *dataT = self.myObject[sender.tag];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@app/transfer/file?v=%@",baseurl,dataT.video.path]];
    
    MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    
    
    mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    
    [mpvc.moviePlayer setContentURL:url];
    
    [self presentMoviePlayerViewControllerAnimated:mpvc];
    
}

-(void)playVideoSelf:(UIButton*)sender
{
    ChatVideo *dataT = self.myObject[sender.tag];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",dataT.video.path]];
    
    MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    
    [mpvc.moviePlayer setContentURL:url];
    
    [self presentMoviePlayerViewControllerAnimated:mpvc];
    
}


-(void)moviePlaybackDidFinish:(NSNotification*)aNotification {
    // [self dismissMoviePlayerViewControllerAnimated];
    // [[NSNotificationCenter defaultCenter] removeObserver:self
    //                                       name:MPMoviePlayerPlaybackDidFinishNotification
    //                                       object:nil];
}

-(NSString*) AgoStringFromTime : (NSDate*) dateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    return  [dateFormatter stringFromDate:dateTime];
}

-(NSString*) AgoStringFromTime2 : (NSDate*) dateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a dd/MMM/YY"];
    
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    return  [dateTime formattedAsTimeAgo];//[dateFormatter stringFromDate:dateTime];
}

-(NSString*) AgoStringFromTime3 : (NSDate*) dateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a dd/MMM/YY"];
    
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    return  [dateFormatter stringFromDate:dateTime];
}

#pragma mark - tcpSocketDelegate
-(void)receivedMessage:(NSString *)data
{
    
    
    NSError* err = nil;
    SocketResponse *response = [[SocketResponse alloc] initWithString:data error:&err];
    
    // NSLog(@"Received %@ %@",response,err);
    
    if([response.responseStat.tag isEqualToString:@"textchat"])
    {
        
        NSLog(@"Here");
        
        SocketTextResponse *responseT = [[SocketTextResponse alloc] initWithString:data error:&err];
        
        
        
        if(responseT.responseData.appCredential.id == self.contact.id )
        {
            
            [self acknowledgementWithChatid:responseT.responseData.chatId appCredential:responseT.responseData.appCredential];
            NSData *strData = [responseT.responseData.text dataUsingEncoding:NSUTF8StringEncoding];
            responseT.responseData.text  = [[NSString alloc] initWithData:strData encoding:NSNonLossyASCIIStringEncoding];
            
            
            
            [self.myObject addObject:responseT.responseData];
            self.history = false;
            [self.tableData reloadData];
            
            NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
            [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
        }
    }
    
    if([response.responseStat.tag isEqualToString:@"chatphoto_transfer"])
    {
        
        SocketPhotoResponse *responseT = [[SocketPhotoResponse alloc] initWithString:data error:&err];
        
        
        
        if(responseT.responseData.appCredential.id == self.contact.id )
        {
            
            
            
            [self acknowledgementWithChatid:responseT.responseData.chatId appCredential:responseT.responseData.appCredential];
            
            [self.myObject addObject:responseT.responseData];
            self.history = false;
            [self.tableData reloadData];
            
            
            NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
            [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
        }
    }
    
    if([response.responseStat.tag isEqualToString:@"chat_video_transfer"])
    {
        
        SocketVideoResponse *responseT = [[SocketVideoResponse alloc] initWithString:data error:&err];
        
        NSLog(@"%@",responseT);
        
        if(responseT.responseData.appCredential.id == self.contact.id )
        {
            
            [self acknowledgementWithChatid:responseT.responseData.chatId appCredential:responseT.responseData.appCredential];
            
            [self.myObject addObject:responseT.responseData];
            self.history = false;
            [self.tableData reloadData];
            
            
            NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
            [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
        }
    }
    
    if([response.responseStat.tag isEqualToString:@"chatprivatephoto_transfer"])
    {
        
        SocketPhotoResponse *responseT = [[SocketPhotoResponse alloc] initWithString:data error:&err];
        
        
        
        if(responseT.responseData.appCredential.id == self.contact.id )
        {
            
            [self acknowledgementWithChatid:responseT.responseData.chatId appCredential:responseT.responseData.appCredential];
            
            [self.myObject addObject:responseT.responseData];
            self.history = false;
            [self.tableData reloadData];
            
            
            
            NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
            [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
        }
    }
    
    if([response.responseStat.tag isEqualToString:@"chatlocation_share"])
    {
        
        SocketLocationResponse *responseT = [[SocketLocationResponse alloc] initWithString:data error:&err];
        
        if(responseT.responseData.appCredential.id == self.contact.id )
        {
            
            [self acknowledgementWithChatid:responseT.responseData.chatId appCredential:responseT.responseData.appCredential];
            
            [self.myObject addObject:responseT.responseData];
            self.history = false;
            [self.tableData reloadData];
            
            NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
            [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
        }
    }
    
    if([response.responseStat.tag isEqualToString:@"chatcontact_share"])
    {
        
        SocketContactResponse *responseT = [[SocketContactResponse alloc] initWithString:data error:&err];
        
        if(responseT.responseData.appCredential.id == self.contact.id )
        {
            
            [self acknowledgementWithChatid:responseT.responseData.chatId appCredential:responseT.responseData.appCredential];
            
            [self.myObject addObject:responseT.responseData];
            self.history = false;
            [self.tableData reloadData];
            
            NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
            [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
        }
    }
    
    
    
    
    if([response.responseStat.tag isEqualToString:@"user_online"])
    {
        
        AcknowledgementResponse *responseT = [[AcknowledgementResponse alloc] initWithString:data error:&err];
        
        
        
        
        NSTimeInterval timestamp = [responseT.responseData.lastSeen longLongValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
        
        if(responseT.responseData.appCredential.id == self.contact.id )
        {
            NSLog(@"seen date ;%@",  date);
            _subtitleView.text = (responseT.responseData.appCredential.id == self.contact.id && responseT.responseData.isOnline ) ? @"Online" : [NSString stringWithFormat:@"last seen %@",[self AgoStringFromTime2:date]];
            
        }
        
        
    }
    
    if([response.responseStat.tag isEqualToString:@"broad_cast_contact_online_offline"])
    {
        
        AcknowledgementResponse *responseT = [[AcknowledgementResponse alloc] initWithString:data error:&err];
        
        NSLog(@"Broadcast Received %@",responseT);
        
        NSTimeInterval timestamp = [responseT.responseData.lastSeen longLongValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
        
        
        if(responseT.responseData.appCredential.id == self.contact.id )
        {
            NSLog(@"seen date ;%@",  date);
            
            _subtitleView.text = (responseT.responseData.appCredential.id == self.contact.id && responseT.responseData.isOnline ) ? @"Online" : [NSString stringWithFormat:@"last seen %@",[self AgoStringFromTime2:date]];
            
        }
    }
    
    if([response.responseStat.tag isEqualToString:@"chat_received"])
    {
        
        AcknowledgementResponse *responseT = [[AcknowledgementResponse alloc] initWithString:data error:&err];
        
        for (int i=0; i<self.myObject.count;i++) {
            
            if([self.myObject[i] isKindOfClass:[Chat class]] || [self.myObject[i] isKindOfClass:[Date class]])
            {
                
            }
            else if([self.myObject[i] isKindOfClass:[ChatPhoto class]])
            {
                
                ChatPhoto *data = self.myObject[i];
                if(data.tmpChatId == responseT.responseData.tmpChatId)
                {
                    data.chatId = responseT.responseData.chatId;
                    break;
                }
            }
            else
            {
                
                TextChat *data = self.myObject[i];
                
                if([data.tmpChatId isEqual:responseT.responseData.tmpChatId])
                {
                    data.chatId = responseT.responseData.chatId;
                    break;
                }
                
            }
            
        }
    }
    
    if([response.responseStat.tag isEqualToString:@"chat_private_photo_took_snapshot"])
    {
        // AcknowledgementResponse *responseT = [[AcknowledgementResponse alloc] initWithString:data error:&err];
        // [ToastView showToastInParentView:self.view withText:responseT.responseStat.msg withDuaration:2.0];
        
        SocketPhotoResponse *responseT = [[SocketPhotoResponse alloc] initWithString:data error:&err];
        
        if(responseT.responseData.appCredential.id == self.contact.id )
        {
            
            [self acknowledgementWithChatid:responseT.responseData.chatId appCredential:responseT.responseData.appCredential];
            
            [self.myObject addObject:responseT.responseData];
            self.history = false;
            [self.tableData reloadData];
            
            NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
            [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
        }
        
    }
    
    if([response.responseStat.tag isEqualToString:@"chat_private_photo_destroy_acknowledgement"])
    {
        
        
        self.myObject = nil;
        self.myObject = [[NSMutableArray alloc] init];
        self.offset = 0;
        self.loaded = false;
        [self getData:self.offset];
        
    }
    
    if([response.responseStat.tag isEqualToString:@"chat_acknowledgement"])
    {
        
        AcknowledgementResponse *responseT = [[AcknowledgementResponse alloc] initWithString:data error:&err];
        
        _subtitleView.text = (responseT.responseData.appCredential.id == self.contact.id && responseT.responseData.isOnline ) ? @"Online" : @"Offline";
        
        for (int i=0; i<self.myObject.count;i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            if([self.myObject[i] isKindOfClass:[Chat class]])
            {
                
                Chat *data = self.myObject[i];
                
                if(data.chatId == responseT.responseData.chatId && responseT.responseData.isRead)
                {
                    if (data.to == self.app.authCredential.id) {
                        
                        if(data.type == 0)
                        {
                            SenderTableViewCell *cell = (SenderTableViewCell *)[self.tableData cellForRowAtIndexPath:indexPath];
                            cell.check.image = [UIImage imageNamed:@"seen"];
                        }
                        else
                        {
                            SenderImageTableViewCell *cell = (SenderImageTableViewCell *)[self.tableData cellForRowAtIndexPath:indexPath];
                            cell.check.image = [UIImage imageNamed:@"seen"];
                        }
                    }
                    
                    [self.tableData reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableData reloadData];
                    
                    break;
                }
                
            }
            else if([self.myObject[i] isKindOfClass:[ChatPhoto class]])
            {
                
                ChatPhoto *data = self.myObject[i];
                if(data.chatId == responseT.responseData.chatId && responseT.responseData.isRead)
                {
                    
                    if (data.send)
                    {
                        SenderImageTableViewCell *cell = (SenderImageTableViewCell *)[self.tableData cellForRowAtIndexPath:indexPath];
                        cell.check.image = [UIImage imageNamed:@"seen"];
                        
                    }
                    
                    [self.tableData reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableData reloadData];
                    
                    break;
                }
            }
            else if([self.myObject[i] isKindOfClass:[Date class]])
            {
                
            }
            else
            {
                
                TextChat *data = self.myObject[i];
                
                if([data.chatId isEqual:responseT.responseData.chatId] && responseT.responseData.isRead)
                {
                    if (data.send)
                    {
                        SenderTableViewCell *cell = (SenderTableViewCell *)[self.tableData cellForRowAtIndexPath:indexPath];
                        cell.check.image = [UIImage imageNamed:@"seen"];
                    }
                    
                    [self.tableData reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableData reloadData];
                    
                    break;
                }
                
                
                
            }
            
        }
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)takePhoto:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    else
    {
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (self.isVideo)
    {
        NSLog(@"Video");
        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    }
    
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if (self.isVideo)
    {
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
        {
            NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
            NSString *moviePath = [videoUrl path];
            
            NSLog(@"VIDEO : %@",moviePath);
            
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                // UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
                
                NSData *byteData = [NSData dataWithContentsOfFile:moviePath];
                
                ChatVideo *dataChat = [[ChatVideo alloc]init];
                dataChat.caption = @"";
                dataChat.appCredential = (AppCredential*)self.contact;
                dataChat.send = true;
                dataChat.recevice = false;
                dataChat.createdDate = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                
                VideoDetails *video = [[VideoDetails alloc]init];
                
                video.path = moviePath;
                
                dataChat.video = video;
                
                self.type.text = @"";
                
                
                [self.myObject addObject:dataChat];
                
                
                
                NSError* error;
                
                SocketResponse *response = [[SocketResponse alloc]init];
                
                SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
                
                responseStat.status = true;
                responseStat.tag = @"chat_video_transfer";
                
                response.responseStat = responseStat;
                response.responseData = dataChat;
                
                
                
                
                NSData *dataR = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
                NSString* jsonString = [[NSString alloc] initWithData:dataR encoding:NSUTF8StringEncoding];
                
                jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
                jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
                
                
                [[SocektAccess getSharedInstance] sendVideoWithContactId:self.app.authCredential.id jsonString:jsonString byteData:byteData filename:moviePath];
                
                // [self.chatSocket sendMessage:jsonString];
                
                
                
                
                self.history = false;
                [self.tableData reloadData];
                
                NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
                [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
                
                self.isVideo = false;
            }
        }
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else
    {
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        [self dismissViewControllerAnimated:YES completion:NULL];
        
        NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
        {
            ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
            self.imageName = [imageRep filename];
            
            if (self.isPrivate)
            {
                self.imageToSend = image;
                self.isPrivate = false;
                self.timer = 0;
                [self performSegueWithIdentifier:@"showPrivate" sender:self];
            }
            else
            {
                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                              initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
                [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
                
                [self.view addSubview:activityIndicator];
                [activityIndicator startAnimating];
                ChatPhoto *dataO = [[ChatPhoto alloc]init];
                dataO.tmpChatId = [self uuid];
                dataO.caption = @"";
                dataO.appCredential = (AppCredential*)self.contact;
                dataO.send = true;
                dataO.recevice = false;
                dataO.createdDate = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                dataO.base64Img = [self imageToString:image];
                
                self.type.text = @"";
                
                
                [self.myObject addObject:dataO];
                
                ChatPhoto *data = [[ChatPhoto alloc]init];
                data.tmpChatId = [self uuid];
                data.caption = @"";
                data.appCredential = (AppCredential*)self.contact;
                data.send = true;
                data.recevice = false;
                data.createdDate = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                data.base64Img = @"";
                
                NSError* error;
                
                SocketResponse *response = [[SocketResponse alloc]init];
                
                SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
                
                responseStat.status = true;
                responseStat.tag = @"chatphoto_transfer";
                
                response.responseStat = responseStat;
                response.responseData = data;
                
                NSData *byteData = UIImagePNGRepresentation(image);
                
                
                NSData *dataR = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
                NSString* jsonString = [[NSString alloc] initWithData:dataR encoding:NSUTF8StringEncoding];
                
                jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
                jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
                
                NSLog(@"photo data : %@",jsonString);
                
                [[SocektAccess getSharedInstance] sendPhotoWithContactId:self.app.authCredential.id jsonString:jsonString byteData:byteData filename:self.imageName];
                
                // [self.chatSocket sendMessage:jsonString];
                
                
                
                
                self.history = false;
                [self.tableData reloadData];
                
                NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
                [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
            }
            
            
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    }
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(NSString*) imageToString : (UIImage*) image{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    return [imageData base64EncodedStringWithOptions:0];
}

- (UIImage *) stringToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender {
    
    if ([segue.identifier isEqualToString:@"showPrivate"])
    {
        PrivatePhotoViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.image = self.imageToSend;
        
    }
    
    if ([segue.identifier isEqualToString:@"showLocation"])
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        if([self.myObject[indexPath.row] isKindOfClass:[Chat class]])
        {
            Chat *post = self.myObject[indexPath.row];
            ShareLocationViewController *data = [segue destinationViewController];
            data.hidesBottomBarWhenPushed = YES;
            data.title = post.extra.name;
            data.place = (Places*) post.extra;
            
        }
        else
        {
            ChatLocation *post = self.myObject[sender.tag];
            ShareLocationViewController *data = [segue destinationViewController];
            data.hidesBottomBarWhenPushed = YES;
            data.title = post.places.name;
            data.place = post.places;
        }
        
        
    }
    
    if ([segue.identifier isEqualToString:@"friendsProfileContact"])
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        if([self.myObject[indexPath.row] isKindOfClass:[Chat class]])
        {
            Chat *post = self.myObject[indexPath.row];
            FriendsProfileViewController *data = [segue destinationViewController];;
            data.hidesBottomBarWhenPushed = YES;
            data.owner = (AppCredential*) post.extra;
            
            
        }
        else
        {
            ChatContact *post = self.myObject[sender.tag];
            FriendsProfileViewController *data = [segue destinationViewController];;
            data.hidesBottomBarWhenPushed = YES;
            data.owner = (AppCredential*) post.contact;
        }
        
        
        
    }
    
    
    if ([segue.identifier isEqualToString:@"friendsProfile"])
    {
        
        FriendsProfileViewController *data = [segue destinationViewController];;
        data.hidesBottomBarWhenPushed = YES;
        data.owner = (AppCredential*) self.contact;
        
    }
    
    
    if ([segue.identifier isEqualToString:@"showChat"])
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        if([self.myObject[indexPath.row] isKindOfClass:[Chat class]])
        {
            Chat *post = self.myObject[indexPath.row];
            ChatViewController *data = [segue destinationViewController];;
            data.hidesBottomBarWhenPushed = YES;
            data.contact =  (Contact*) post.extra;
            
            
            
        }
        else
        {
            ChatContact *post = self.myObject[sender.tag];
            ChatViewController *data = [segue destinationViewController];;
            data.hidesBottomBarWhenPushed = YES;
            data.contact = post.contact;
            
        }
        
        
    }
    
    if ([segue.identifier isEqualToString:@"chatDetails"])
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        UIImage *image = [[UIImage alloc]init];
        BOOL isPrivate = false;
        int timer;
        NSDate *createdDate;
        ChatPhoto *photoData;
        
        if([self.myObject[indexPath.row] isKindOfClass:[Chat class]])
        {
            Chat *data = self.myObject[indexPath.row];
            if (data.to == self.app.authCredential.id)
            {
                SenderImageTableViewCell *cell = (SenderImageTableViewCell*)[self.tableData cellForRowAtIndexPath:indexPath];
                image = cell.imageValue;
                
            }
            else
            {
                ReceiverImageTableViewCell *cell = (ReceiverImageTableViewCell*)[self.tableData cellForRowAtIndexPath:indexPath];
                image = cell.imageValue;
            }
            
            if (data.type == 5) {
                
                NSTimeInterval timestamp = [data.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                ChatPhoto *photo = (ChatPhoto*) data.extra;
                
                timer=photo.timer;
                createdDate = date;
                isPrivate = true;
                photoData = photo;
            }
        }
        else
        {
            ChatPhoto *dataT = self.myObject[indexPath.row];
            
            if (dataT.send)
            {
                SenderImageTableViewCell *cell = (SenderImageTableViewCell*)[self.tableData cellForRowAtIndexPath:indexPath];
                image = cell.imageValue;
            }
            else
            {
                ReceiverImageTableViewCell *cell = (ReceiverImageTableViewCell*)[self.tableData cellForRowAtIndexPath:indexPath];
                image = cell.imageValue;
            }
            
            if (dataT.timer) {
                
                NSTimeInterval timestamp = [dataT.createdDate longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                
                timer=dataT.timer;
                createdDate = date;
                isPrivate = true;
                photoData = dataT;
                
            }
            
        }
        
        
        ChatDetailsViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.navigationController.navigationBarHidden = YES;
        data.image = image;
        data.isPrivate = isPrivate;
        data.data = photoData;
        data.timerValue = timer;
        
    }
    
}

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    
    
    if ([tag isEqualToString:@"getChatData"])
    {
        NSError* error = nil;
        self.response = [[ChatResponse alloc] initWithDictionary:data error:&error];
       // NSLog(@"chathistoryResponse: %@",self.response);
        
        
        if(self.response.responseStat.status){
            
            for(int i=0;i<self.response.responseData.count;i++)
            {
                BOOL isDate = false;
                
                if ( i == 0)
                {
                    Chat *data = self.response.responseData[i];
                    NSTimeInterval timestamp = [data.createdDate longLongValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MMMM dd"];
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                    
                    
                    
                    if ([self isSameDayWithDate1:currentDate date2:date]) {
                        
                        [self.myObject removeObject:data] ;
                    }
                    
                    Date *dateO = [[Date alloc] init];
                    dateO.createdDate = data.createdDate;
                    dateO.dateString = [dateFormatter stringFromDate:date];
                    
                    [self.myObject insertObject:dateO atIndex:i];
                    currentDate = date;
                    isDate = true;
                    
                    
                }
                else
                {
                    Chat *data = self.response.responseData[i];
                    NSTimeInterval timestamp = [data.createdDate longLongValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MMMM dd"];
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                    
                    Chat *data2 = self.response.responseData[i-1];
                    NSTimeInterval timestamp2 = [data2.createdDate longLongValue];
                    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:timestamp2];
                    
                    if (![self isSameDayWithDate1:date date2:date2]) {
                        Date *dateO = [[Date alloc] init];
                        dateO.createdDate = data.createdDate;
                        dateO.dateString = [dateFormatter stringFromDate:date];
                        //[self.myObject addObject:dateO];
                        [self.myObject insertObject:dateO atIndex:i];
                        isDate = true;
                        
                        
                    }
                    
                    
                }
                
                
                
                // [self.myObject addObject:self.response.responseData[i]];
               
                
                [self.myObject insertObject:self.response.responseData[i] atIndex:i+1];
                
                
            }
        }
        
        self.history = self.response.responseStat.status;
        self.isData = self.response.responseStat.status;
        self.loaded = self.response.responseStat.status;
        self.offset = (self.response.responseStat.status) ? self.offset +1 : self.offset;
        [self.tableData reloadData];
        
        if (self.offset<2)
        {
            if (self.myObject.count > 0)
            {
                NSIndexPath* ipath = [NSIndexPath indexPathForRow:self.myObject.count-1 inSection:0];
                [self.tableData scrollToRowAtIndexPath: ipath atScrollPosition:UITableViewScrollPositionBottom animated: YES];
            }
        }
        
        
        
    }
    if([tag isEqualToString:@"deleteChatData"]){
        [ToastView showErrorToastInParentView:self.view withText:@"message deleted " withDuaration:2.0];
        [self getData:self.offset];
       // [self.tableData reloadData];
    }
    
    
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
    if ([tag isEqualToString:@"getChatData"])
    {
        [self.tableData reloadData];
    }
    if([tag isEqualToString:@"deleteChatData"]){
        NSLog(@"chat delete error :%@",error);
    }
    
}

- (BOOL)isSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

-(NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}


@end
