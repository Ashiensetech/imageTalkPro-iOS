//
//  CommentsViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/15/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentResponse.h"
#import "Response.h"
#import "AppDelegate.h"
#import "ApiAccess.h"

@interface CommentsViewController : UIViewController <ApiAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}

@property (strong, nonatomic) IBOutlet UIView *textView;
@property (strong, nonatomic)  NSMutableArray *myObject;
@property (strong, nonatomic)  AppDelegate *app;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) int postId;
@property (nonatomic, assign) int postOwnerId;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) IBOutlet UITextField *commentTxt;
@property (strong, nonatomic) IBOutlet UITableView *tableData;
@property (strong, nonatomic) CommentResponse *response;
@property (strong, nonatomic) CommentResponse *responseAdd;
@property (strong, nonatomic) Response *responseDelete;

@end
