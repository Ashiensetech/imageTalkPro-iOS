//
//  LikesViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/28/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "LikesViewController.h"
#import "JSONHTTPClient.h"
#import "ToastView.h"
#import "LikesTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FriendsProfileViewController.h"
#import "ApiAccess.h"

@interface LikesViewController ()

@end

@implementation LikesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    
    self.tableData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    self.myObject = [[NSMutableArray alloc] init];
    
    self.offset = 0;
    self.loaded = false;
    [self getData:self.offset];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if(y > h + reload_distance) {
        
        
        if(self.isData && self.loaded)
        {
            
            self.loaded = false;
            [self getData:self.offset];
            
            NSLog(@"load more rows");
        }
        
        
    }
    
}

-(void) getData:(int) offset{
    
    NSDictionary *inventory = @{@"offset" : [NSString stringWithFormat:@"%d",offset],
                                @"post_id" : [NSString stringWithFormat:@"%d",self.postId]
                                };
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/get/likes" params:inventory tag:@"getData"];
    
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LikesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Liker *data = self.myObject[indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%@ %@",data.user.firstName,data.user.lastName];
    cell.click.tag = indexPath.row;
    NSTimeInterval timestamp = [data.createdDate longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, hh:mm a"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    cell.date.text = [NSString stringWithFormat:@"%@",(data.textStatus)?data.textStatus:@""];
  
    
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.user.picPath.original.path]]
                       placeholderImage:nil];
    
    
    
    return cell;
    
}

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    
    if ([tag isEqualToString:@"getData"])
    {
        
        NSError* error = nil;
        self.response = [[LikesResponse alloc] initWithDictionary:data error:&error];
        
        
        
        if(self.response.responseStat.status){
            
            for(int i=0;i<self.response.responseData.count;i++)
            {
                [self.myObject addObject:self.response.responseData[i]];
            }
            
        }
        
        self.isData = self.response.responseStat.status;
        self.loaded = self.response.responseStat.status;
        self.offset = (self.response.responseStat.status) ? self.offset+1 : self.offset;
        [self.tableData reloadData];
        [self.tableData setHidden:(self.myObject.count>0)?NO:YES];
        
    }
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
    if ([tag isEqualToString:@"getData"])
    {
        [self.tableData reloadData];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender {
    if ([segue.identifier isEqualToString:@"friendsProfile"])
    {
        FriendsProfileViewController *data = [segue destinationViewController];
        Liker *post = self.myObject[sender.tag];
        data.hidesBottomBarWhenPushed = YES;
        data.owner = (AppCredential*)post;
        
    }
}


@end
