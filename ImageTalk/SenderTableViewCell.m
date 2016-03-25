//
//  SenderTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/5/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "SenderTableViewCell.h"

@implementation SenderTableViewCell

- (void)awakeFromNib {
    
    self.containerView.layer.cornerRadius = 20.0;
    [self.containerView.layer setMasksToBounds:YES];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
