//
//  NotificationTableViewCell.h
//  ImageTalk
//
//  Created by Workspace Infotech on 1/1/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *text;
@property (strong, nonatomic) IBOutlet UILabel *time;

@end
