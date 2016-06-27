//
//  NotificationViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "UIImage+GIF.h"
#import "UIImageView+RJLoader.h"
#import "NotificationViewController.h"
#import "Notification.h"
#import "WallPost.h"
#import "NewNotificationTableViewCell.h"
#import "ToastView.h"
#import "DetailsViewController.h"
#import "FriendsProfileViewController.h"
@interface NotificationViewController ()
@property(strong,nonatomic) WallPost *post;
@property(strong,nonatomic) AppCredential *person;
@property(assign,nonatomic) BOOL isData;
@property (assign,nonatomic) BOOL loaded;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=NO;
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    socketurl = [defaults objectForKey:@"socketurl"];
    port = [defaults objectForKey:@"port"];
    [[ApiAccess getSharedInstance] setDelegate:self];
    self.notificationsList = [[NSMutableArray alloc] init];
    
    
    
    [self getData:self.offset ];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    self.notificationTable.dataSource = self;
    self.notificationTable.delegate = self;
}

-(void) getData:(int) offset{
    
    if(self.notificationsList ==NULL){
        self.notificationsList = [[NSMutableArray alloc] init];
    }
    NSLog (@"offset: %d",self.offset);
    NSDictionary *inventory = @{@"offset" : [NSString stringWithFormat:@"%d",offset],@"limit":@"20"};
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/user/notification/get/recent" params:inventory tag:@"getNotificationData"];
    
}
#pragma mark - table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.notificationsList.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NewNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    
    Notification *data = self.notificationsList[indexPath.row];
    
    if([data.sourceClass isEqualToString:@"wallpost"]){
        
        NSError* error = nil;
        WallPost *wall = [[WallPost alloc] initWithDictionary:data.source error:&error];
        
        [cell.postImage sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,wall.picPath]]];
        
        
        [cell.postImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabOnPostImage:)];
        tapped.numberOfTapsRequired = 1;
        tapped.cancelsTouchesInView = NO;
        [cell.postImage addGestureRecognizer:tapped];
        cell.postImage.tag = indexPath.row;
        
    }
    
    NSString *name = [NSString stringWithFormat:@"%@ %@",data.person.user.firstName,data.person.user.lastName ];
    
    NSString *notification =  @"";
    if([data.actionTag isEqualToString:@"likepost"]){
        notification = [NSString stringWithFormat: @"%@ Like your photo ", name];
    }
    else if([data.actionTag isEqualToString:@"commentPost"]){
        notification = [NSString stringWithFormat: @"%@ Commented on  your photo ", name];
    }else if([data.actionTag isEqualToString:@"tag"]){
        notification = [NSString stringWithFormat: @"%@ Added you in a photo ", name] ;
    }
    
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:notification];
    
    NSRange range = [notification rangeOfString:name options:NSCaseInsensitiveSearch];
    
    
    [attString beginEditing];
    
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
    [attString  addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:12.0] range:range];
    
    
    [attString endEditing];
    
    cell.userName.text =@"";
    cell.notificationText.attributedText  = attString;
    
    
    [cell.userPic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.person.user.picPath.original.path]]
                    placeholderImage:nil];
    
    
    [cell.userPic setUserInteractionEnabled:YES];
    UITapGestureRecognizer *touchUserPic = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabOnUser:)];
    touchUserPic.numberOfTapsRequired = 1;
    touchUserPic.cancelsTouchesInView = NO;
    [cell.userPic addGestureRecognizer:touchUserPic];
    cell.userPic.tag = indexPath.row;
    
    
    [cell.userName setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *touchUserName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabOnUser:)];
    touchUserName.numberOfTapsRequired = 1;
    touchUserName.cancelsTouchesInView = NO;
    [cell.userName addGestureRecognizer:touchUserName];
    cell.userName.tag = indexPath.row;
    
    return cell;
}

-(void)tabOnPostImage :(id) sender
{
    
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:gesture.view.tag inSection:0];
    Notification *data = self.notificationsList[indexPath.row];
    
    NSError* error = nil;
    
    self.post =  [[WallPost alloc] initWithDictionary:data.source error:&error];
    if(!data.isRead){
        NSDictionary *inventory = @{@"notification_id" : [NSString stringWithFormat:@"%d",self.post.id]};
        [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/user/notification/set/read" params:inventory tag:@"notificationSetRead"];
        
    }
    
    
    
    [self performSegueWithIdentifier:@"post" sender:self];
    
    
}

-(void)tabOnUser :(id) sender
{
    
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:gesture.view.tag inSection:0];
    Notification *data = self.notificationsList[indexPath.row];
    NSLog(@"post id :%@",data.person.user.firstName);
    self.person = data.person;
    
    [self performSegueWithIdentifier:@"friendsProfile" sender:self];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 20;
    
    if(y > h + reload_distance) {
        
        
        if(self.isData && self.loaded)
        {
            
            self.loaded = false;
            [self getData:self.offset];
            
            NSLog(@"load more rows");
            
        }
        
        
    }
}
#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    if([tag isEqualToString:@"getNotificationData"]){
        
        NSError* error = nil;
        self.data = [[NotificationResponse alloc] initWithDictionary:data error:&error];
        
        //        NSLog(@"Ns error :%@",error);
        //        NSLog(@"data : %@",self.data);
        
        if(self.data.responseStat.status)
        {
            
            for(int i=0;i<self.data.responseData.count;i++)
            {
                [self.notificationsList addObject:self.data.responseData[i]];
                
            }
            
            
        }
        self.isData = self.data.responseStat.status;
        self.loaded = self.data.responseStat.status;
        self.offset = (self.data.responseStat.status) ? self.offset+1 : self.offset;
        
        
        [self.notificationTable reloadData];
        
    }
    if([tag isEqualToString:@"notificationSetRead"]){
    }
    
}
-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    if([tag isEqualToString:@"getNotificationData"]){
        NSLog(@"Response : %@", error );
    }
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"post"])
    {
        DetailsViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.data = self.post;
        
    }
    if ([segue.identifier isEqualToString:@"friendsProfile"])
    {
        FriendsProfileViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.owner = self.person;
        
    }
    
}

@end
