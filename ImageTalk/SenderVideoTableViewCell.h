//
//  SenderVideoTableViewCell.h
//  ImageTalk
//
//  Created by Workspace Infotech on 1/15/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SenderVideoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIImageView *check;
@property (strong, nonatomic) IBOutlet UIButton *click;
@property (weak, nonatomic) IBOutlet UIImageView *image;


@end
