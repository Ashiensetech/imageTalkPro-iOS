//
//  NewNotificationTableViewCell.h
//  ImageTalk
//
//  Created by Workspace Infotech on 6/14/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewNotificationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userPic;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *notificationText;
@property (strong, nonatomic) IBOutlet UIImageView *postImage;
@property (strong, nonatomic) IBOutlet UIView *notificationView;

@end
