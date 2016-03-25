//
//  ContactsTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/13/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "ContactsTableViewCell.h"

@implementation ContactsTableViewCell

- (void)awakeFromNib {
    self.profilePic.layer.cornerRadius = 16.0;
    [self.profilePic.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
