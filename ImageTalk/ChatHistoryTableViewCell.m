//
//  ChatHistoryTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/17/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "ChatHistoryTableViewCell.h"

@implementation ChatHistoryTableViewCell

- (void)awakeFromNib {
    self.profilePic.layer.cornerRadius = 25.0;
    [self.profilePic.layer setMasksToBounds:YES];
    
    self.notification.layer.cornerRadius = 11.0;
    [self.notification.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
