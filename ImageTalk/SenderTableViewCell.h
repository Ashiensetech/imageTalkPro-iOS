//
//  SenderTableViewCell.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/5/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SenderTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *text;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIImageView *check;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerPadding;


@end
