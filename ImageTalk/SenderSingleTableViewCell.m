//
//  SenderSingleTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 12/15/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "SenderSingleTableViewCell.h"

@implementation SenderSingleTableViewCell

- (void)awakeFromNib {
    
    self.containerView.layer.cornerRadius = 15.0;
    [self.containerView.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
