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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float limgW =  self.image.image.size.width;
    if(limgW > 0) {
        self.image.frame = CGRectMake(self.image.frame.origin.x,self.image.frame.origin.y,self.image.frame.size.width,self.image.image.size.height);
        self.description.frame = CGRectMake(self.description.frame.origin.x,10,self.description.frame.size.width,self.description.frame.size.height);
//        self.detailTextLabel.frame = CGRectMake(55,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width,self.detailTextLabel.frame.size.height);
    }
}




@end
