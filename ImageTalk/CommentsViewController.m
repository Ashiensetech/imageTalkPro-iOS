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
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
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
    
//    self.textView.layer.cornerRadius = 5;
//    [self.textView.layer setMasksToBounds:YES];
//    
//    self.textView.frame = CGRectInset(self.textView.frame, -1.0f, -1.0f);
//    self.textView.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.textView.layer.borderWidth = 1.0f;
    
    self.tableData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    self.comment.delegate = self;
    
    self.comment.layer.cornerRadius = 5;
    [self.comment.layer setMasksToBounds:YES];
    
    self.comment.text = @"write your comment here...";
    self.comment.textColor = [UIColor lightGrayColor];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    [self getData];
    
}


-(void) viewDidAppear:(BOOL)animated
{
    [[ApiAccess getSharedInstance] setDelegate:self];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.comment resignFirstResponder];
}
-(void)dismissKeyboard {
    
    [self.comment resignFirstResponder];
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
    
    if([self.comment.text isEqualToString:@"write your comment here..."] || [self.comment.text isEqualToString:@""])
    {
         [ToastView showErrorToastInParentView:self.view withText:@"please write your comment first" withDuaration:2.0];
    }
    else
    {
        NSDictionary *inventory = @{
                                    @"post_id" : [NSString stringWithFormat:@"%d",self.postId],
                                    @"comment" : self.comment.text
                                    };
        
        [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/create/comment" params:inventory tag:@"createComment"];
        
    }
    
   
    
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
    CGFloat height ;
    height = 20 ;
    
     PostComment *data = self.myObject[indexPath.row];
    
    CGSize size = [data.comment sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:CGSizeMake(516, 1100) ];
    height = height + ((size.height < 40)? 40 : size.height);
  //  NSLog(@"nslog :%f",height);
    return height;
    
   // return UITableViewAutomaticDimension;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PostComment *data = self.myObject[indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%@ %@",data.commenter.user.firstName,data.commenter.user.lastName];
    cell.click.tag = indexPath.row;
    NSLog(@"date: %@",data.createdDate);
//    NSTimeInterval timestamp = [data.createdDate longLongValue];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MMMM dd, hh:mm a"];
//    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMMM dd, hh:mm a";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
    
    
    NSDate *old =  [dateFormatter dateFromString:data.createdDate];
    
    NSLog(@"The old time in current date format: %@",old);
    cell.date.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:old]];
    
 cell.commentTextView.text = [NSString stringWithFormat:@"%@",data.comment];

    CGRect frame = cell.commentTextView.frame;
    frame.size.height = cell.commentTextView.contentSize.height;
    cell.commentTextView.frame=frame;
    
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.commenter.user.picPath.original.path]]
                       placeholderImage:nil];
    
    
    
    return cell;
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
     PostComment *data = self.myObject[indexPath.row];
    
    if (self.app.authCredential.id == data.commenter.id || self.app.authCredential.id == self.postOwnerId)
    {
        NSLog(@"Delete");
        
       
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:(self.app.authCredential.id == data.commenter.id || self.app.authCredential.id == self.postOwnerId)?[NSString stringWithFormat:@"Delete"]:[NSString stringWithFormat:@""]  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            NSLog(@"Delete");
            
            
            NSDictionary *inventory = @{@"comment_id" : [NSString stringWithFormat:@"%d",data.id]};
            [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/delete/comment" params:inventory tag:@"deleteComment"];
            
            
            
            
        }];
        
        deleteAction.backgroundColor = [UIColor redColor];
        
        
        UITableViewRowAction *replyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:[NSString stringWithFormat:@"Reply"] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            NSLog(@"reply");
            
            
            
            
            
        }];
        
        replyAction.backgroundColor = [UIColor grayColor];
        
        return @[replyAction,deleteAction];
        
    }
    else{
        UITableViewRowAction *replyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:[NSString stringWithFormat:@"Reply"] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            NSLog(@"reply");
            
            
            
            
            
        }];
        
        replyAction.backgroundColor = [UIColor grayColor];
        
        return @[replyAction];

    }
    
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
       // [self.commentTxt resignFirstResponder];
        [self.comment resignFirstResponder];
        if(self.responseAdd.responseStat.status)
        {
            self.comment.text = @"write your comment here...";
            self.comment.textColor = [UIColor lightGrayColor];
          //  self.commentTxt.text=@"";
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


#pragma mark - TextViewDelegate 
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"write your comment here..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"write your comment here...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
  
}


@end
