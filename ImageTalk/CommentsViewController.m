//
//  CommentsViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/15/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "CommentsViewController.h"
#import "JSONHTTPClient.h"
#import "CommentsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TimelineViewController.h"
#import "FriendsProfileViewController.h"
#import "ApiAccess.h"
#import "ToastView.h"

@interface CommentsViewController ()
@property TimelineViewController *timeLine;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:self.singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(keyboardDidShowOrHide:)
     name:UIKeyboardWillShowNotification
     object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(keyboardDidShowOrHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    
    self.app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.textView.layer.cornerRadius = 5;
    [self.textView.layer setMasksToBounds:YES];
    
    self.textView.frame = CGRectInset(self.textView.frame, -1.0f, -1.0f);
    self.textView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.textView.layer.borderWidth = 1.0f;
    
    self.tableData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
   
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    [self getData];

}

-(void) viewDidAppear:(BOOL)animated
{
    [[ApiAccess getSharedInstance] setDelegate:self];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.commentTxt resignFirstResponder];
}

-(void)keyboardDidShowOrHide:(NSNotification *)notification
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


- (IBAction)add:(id)sender {
    
    NSDictionary *inventory = @{
                                @"post_id" : [NSString stringWithFormat:@"%d",self.postId],
                                @"comment" : self.commentTxt.text
                                };
    
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/create/comment" params:inventory tag:@"createComment"];

}

-(void) getData{
    self.myObject = [[NSMutableArray alloc] init];
    NSDictionary *inventory = @{@"post_id" : [NSString stringWithFormat:@"%d",self.postId]};
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/get/comment/all" params:inventory tag:@"getCommentData"];
    
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
    //minimum size of your cell, it should be single line of label if you are not clear min. then return UITableViewAutomaticDimension;
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PostComment *data = self.myObject[indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%@ %@",data.commenter.user.firstName,data.commenter.user.lastName];
    cell.click.tag = indexPath.row;
    NSTimeInterval timestamp = [data.createdDate longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, hh:mm a"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    cell.date.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
   
    cell.comment.text = [NSString stringWithFormat:@"%@",data.comment];
    
    
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.commenter.user.picPath.original.path]]
                       placeholderImage:nil];
    
    
    
    return cell;
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSLog(@"Delete");
   
        PostComment *data = self.myObject[indexPath.row];
        
    
    
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:(self.app.authCredential.id == data.commenter.id || self.app.authCredential.id == self.postOwnerId)?[NSString stringWithFormat:@"Delete"]:[NSString stringWithFormat:@""]  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            NSLog(@"Delete");
            
            if (self.app.authCredential.id == data.commenter.id || self.app.authCredential.id == self.postOwnerId)
            {
            
                NSDictionary *inventory = @{@"comment_id" : [NSString stringWithFormat:@"%d",data.id]};
                [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/delete/comment" params:inventory tag:@"deleteComment"];
            
            }

            
            
        }];
    
        deleteAction.backgroundColor = [UIColor redColor];
        
        
        return @[deleteAction];
   
    
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    
    if ([tag isEqualToString:@"getCommentData"])
    {
        NSError* error = nil;
        self.response = [[CommentResponse alloc] initWithDictionary:data error:&error];
        
        if(self.response.responseStat.status){
            
                for(int i=0;i<self.response.responseData.count;i++)
                {
                    [self.myObject addObject:self.response.responseData[i]];
                }
            
        }
        
        
        [self.tableData setHidden:(self.myObject.count>0) ? NO : YES];
        [self.tableData reloadData];
      
        
    }
    
    
    if ([tag isEqualToString:@"createComment"])
    {
        
        NSError* error = nil;
        NSLog(@"createComment inside");
        NSLog(@"%@",self.navigationController.viewControllers);
       
        self.responseAdd = [[CommentResponse alloc] initWithDictionary:data error:&error];
        [self.commentTxt resignFirstResponder];
        
        if(self.responseAdd.responseStat.status)
        {
            self.commentTxt.text=@"";
            [self getData];
            TimelineViewController *t = (TimelineViewController *)self.navigationController.viewControllers[0];
            t.updateWill = YES;
            t.updateId = self.index;
            t.updateValue =(int)self.response.responseData.count+1;
            NSLog(@"response %d",(int)self.response.responseData.count);
            
        }
    }
    
    
    if ([tag isEqualToString:@"deleteComment"])
    {
        
        NSError* error = nil;
        self.responseDelete = [[Response alloc] initWithDictionary:data error:&error];
        
           
        if(self.responseDelete.responseStat.status)
        {
            [self getData];
        }
    }

    

    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
    if ([tag isEqualToString:@"getCommentData"])
    {
        [self.tableData reloadData];
    }
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender {
    if ([segue.identifier isEqualToString:@"friendsProfile"])
    {
        FriendsProfileViewController *data = [segue destinationViewController];
        PostComment *post = self.myObject[sender.tag];
        data.hidesBottomBarWhenPushed = YES;
        data.owner = (AppCredential*)post.commenter;
        
    }
}





@end
