//
//  NewNotificationTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 6/14/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import "NewNotificationTableViewCell.h"

@implementation NewNotificationTableViewCell
- (void)awakeFromNib {
    
    self.userPic.layer.cornerRadius = 16.0;
    [self.userPic.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
