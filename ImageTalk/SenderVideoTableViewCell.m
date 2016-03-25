//
//  SenderVideoTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 1/15/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import "SenderVideoTableViewCell.h"

@implementation SenderVideoTableViewCell

- (void)awakeFromNib {
    
    self.containerView.layer.cornerRadius = 20.0;
    [self.containerView.layer setMasksToBounds:YES];
    
    self.image.layer.cornerRadius = 20.0;
    [self.image.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
