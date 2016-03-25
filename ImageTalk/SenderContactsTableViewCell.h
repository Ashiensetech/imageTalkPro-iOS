//
//  SenderContactsTableViewCell.h
//  ImageTalk
//
//  Created by Workspace Infotech on 12/1/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SenderContactsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIImageView *check;
@property (strong, nonatomic) IBOutlet UIButton *click;
@property (strong, nonatomic) IBOutlet UIButton *messageClick;

@end
