//
//  TimelineTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/8/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "TimelineTableViewCell.h"

@implementation TimelineTableViewCell

@synthesize description;

- (void)awakeFromNib {
    self.profilePic.layer.cornerRadius = 20.0;
    [self.profilePic.layer setMasksToBounds:YES];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
