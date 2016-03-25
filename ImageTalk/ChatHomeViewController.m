//
//  ChatHomeViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/22/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "ChatHomeViewController.h"
#import "ChatViewController.h"
#import "ChatHistoryTableViewCell.h"
#import "JSONHTTPClient.h"
#import "ToastView.h"
#import "UIImageView+WebCache.h"
#import "ApiAccess.h"
#import "SelectContactViewController.h"
#import "SocektAccess.h"
#import "SocketResponse.h"
#import "AcknowledgementResponse.h"


@interface ChatHomeViewController ()

@end

@implementation ChatHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    socketurl = [defaults objectForKey:@"socketurl"];
    port = [defaults objectForKey:@"port"];
    
    self.tableData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    self.app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void) timerTickWithChatId:(NSString *)chatId interval:(int)interval
{
}

-(void) timerFinishWithChatId:(NSString *)chatId
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [[ApiAccess getSharedInstance] setDelegate:self];
    [[[SocektAccess getSharedInstance]getSocket]setDelegate:self];
    [[[SocektAccess getSharedInstance]getSocket] reconnect];
    _chatSocket =[[SocektAccess getSharedInstance]getSocket];
    
    [[TimerAccess getSharedInstance] setDelegate:self];
    [[TimerAccess getSharedInstance] initial];
    
    self.tabBarController.tabBar.hidden=NO;
    [[SocektAccess getSharedInstance] emptyBadge];
    [self getData];
}

-(void) getData{
    
    NSDictionary *inventory = @{};
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/user/chat/showLatest" params:inventory tag:@"getChatHomeData"];
    
}

#pragma mark - table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.response.responseData.count;
    
}

-(NSString*) AgoStringFromTime : (NSDate*) dateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    return  [dateFormatter stringFromDate:dateTime];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    ChatHistory *data=[self.response.responseData objectAtIndex:indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%@ %@",data.contact.user.firstName,data.contact.user.lastName];
 
    Chat *chat = data.chat[0];
    
    NSTimeInterval timestamp = [chat.createdDate longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    cell.time.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];

    
    if (chat.type == 0)
    {
        cell.sub.text = [NSString stringWithFormat:@"%@",chat.chatText];
    }
    else if (chat.type == 3)
    {
        cell.sub.text = [NSString stringWithFormat:@"Location Message"];
    }
    else if (chat.type == 4)
    {
        cell.sub.text = [NSString stringWithFormat:@"Contact Message"];
    }
    else if (chat.type == 5)
    {
        cell.sub.text = [NSString stringWithFormat:@"Private Photo Message"];
    }
    else
    {
        cell.sub.text = [NSString stringWithFormat:@"Photo Message"];
    }
    
    
    
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.contact.user.picPath.original.path]]
                       placeholderImage:nil];
    
    cell.time.textColor = (!chat.readStatus && chat.from!=self.app.authCredential.id) ? [UIColor redColor]:[UIColor lightGrayColor];
    cell.sub.textColor = (!chat.readStatus && chat.from!=self.app.authCredential.id) ? [UIColor redColor]:[UIColor lightGrayColor];
    cell.notification.text = [NSString stringWithFormat:@"%d",data.unRead];
    cell.notification.hidden = (!chat.readStatus && chat.from!=self.app.authCredential.id) ? false:true;
  
    
    return cell;
    
}


#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{

    
    if ([tag isEqualToString:@"getChatHomeData"])
    {
        NSError* error = nil;
        self.response = [[ChatHistoryResponse alloc] initWithDictionary:data error:&error];
        
       
        [self.tableData reloadData];
         self.tableData.hidden = (self.response.responseData.count > 0) ? NO : YES;
         self.emptyView.hidden = (self.response.responseData.count > 0) ? YES : NO;        
       
    }
    
    
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
    if ([tag isEqualToString:@"getChatHomeData"])
    {
        self.tableData.hidden = true;
        self.emptyView.hidden = false;
        [self.tableData reloadData];
    }
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showChat"])
    {
        NSIndexPath *indexPath = [self.tableData indexPathForSelectedRow];
        ChatViewController *data = [segue destinationViewController];
        ChatHistory *post = self.response.responseData[indexPath.row];
        data.hidesBottomBarWhenPushed = YES;
        data.contact = post.contact;
    }
    
    if ([segue.identifier isEqualToString:@"showSelect"])
    {
       
        SelectContactViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
       
    }


}

#pragma mark - tcpSocketDelegate
-(void)receivedMessage:(NSString *)data
{
    
    NSError* err = nil;
    SocketResponse *response = [[SocketResponse alloc] initWithString:data error:&err];
    
    if([response.responseStat.tag isEqualToString:@"textchat"] || [response.responseStat.tag isEqualToString:@"chatphoto_transfer"] || [response.responseStat.tag isEqualToString:@"chatprivatephoto_transfer"] || [response.responseStat.tag isEqualToString:@"chatlocation_share"] || [response.responseStat.tag isEqualToString:@"chatcontact_share"] || [response.responseStat.tag isEqualToString:@"chat_private_photo_took_snapshot"])
    {
        [SocektAccess getSharedInstance].badgeValue++;
        [[SocektAccess getSharedInstance]setBadge];
        [self getData];
    }
    
}


@end
