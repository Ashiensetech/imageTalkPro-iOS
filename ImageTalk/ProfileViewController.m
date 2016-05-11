//
//  ProfileViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "AllPhotosViewController.h"
#import "NumbersViewController.h"
#import "JSONHTTPClient.h"
#import "ToastView.h"
#import "ApiAccess.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"Profile";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    self.app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
   
    
    self.profilePic.layer.cornerRadius = 45;
    [self.profilePic.layer setMasksToBounds:YES];
    
   
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:self.singleTap];
    [self getData:self.app.userId];
   
}


-(void) getData:(NSString*) ownerId{
    
    NSDictionary *inventory = @{@"owner_id":ownerId};
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"/app/wallpost/count/byownerid" params:inventory tag:@"postCount"];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    
    if(![self.app.userPic isEqual:@""])
    {
        [self.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,self.app.userPic]]
                           placeholderImage:nil];
    }
    
    self.textStaus.text = self.app.textStatus;
    self.wallpost.text = [NSString stringWithFormat:@"%d",self.app.wallpost];
    
    self.profilePic.layer.cornerRadius = 45;
    [self.profilePic.layer setMasksToBounds:YES];
    
    self.tabBarController.tabBar.hidden=NO;

}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.textStaus resignFirstResponder];
}

- (IBAction)changeStatus:(id)sender {
    
    [self.loading startAnimating];
    NSDictionary *inventory = @{@"text_status" : (self.textStaus.text)?self.textStaus.text:@" "};
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/profile/change/status" params:inventory tag:@"changeStatus"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    [self.loading stopAnimating];
    
    if ([tag isEqualToString:@"changeStatus"])
    {
        
        NSError* error = nil;
        self.response = [[StatusResponse alloc] initWithDictionary:data error:&error];
        self.textStaus.text = (self.response.responseStat.status) ? self.response.responseData.textStatus : @"";
        
        
    }
    else if([tag isEqualToString:@"postCount"])
    {
        NSError* error = nil;
        self.response = [[StatusResponse alloc] initWithDictionary:data error:&error];
       // self.picCount.text = (self.response.responseStat.status) ?self.response.responseData.textStatus : @"";

        
        NSLog(@"Post count: %@",self.response);
        
    }
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    [self.loading stopAnimating];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"photo"])
    {
       
        AllPhotosViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.isTimeline = NO;
    }
    
    if ([segue.identifier isEqualToString:@"isNumber"])
    {
       
        NumbersViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.title = @"Numbers Exist";
        data.url = @"app/contact/who/has/mine";
    }
    
    if ([segue.identifier isEqualToString:@"notNumber"])
    {
       
        NumbersViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.title = @"Numbers Not Exist";
        data.url = @"app/contact/doesnot/have/mine";
    }
    
    if ([segue.identifier isEqualToString:@"blocked"])
    {
        NumbersViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.title = @"Blocked";
        data.url = @"app/contact/whom/i/blocked";
    }
    
    if ([segue.identifier isEqualToString:@"favorites"])
    {
        
        NumbersViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.title = @"Favorites";
        data.url = @"app/contact/whom/i/blocked";
    }
}
@end
