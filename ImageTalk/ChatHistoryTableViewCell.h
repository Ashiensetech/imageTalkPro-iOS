//
//  ChatHistoryTableViewCell.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/17/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatHistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *sub;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *notification;

@end
