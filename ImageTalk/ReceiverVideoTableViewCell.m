//
//  ReceiverVideoTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 1/15/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import "ReceiverVideoTableViewCell.h"

@implementation ReceiverVideoTableViewCell

- (void)awakeFromNib {
    
    self.containerView.layer.cornerRadius = 20.0;
    [self.containerView.layer setMasksToBounds:YES];
    
   // self.containerView.frame = CGRectInset(self.containerView.frame, -0.5f, -0.5f);
   // self.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
   // self.containerView.layer.borderWidth = 0.5f;
    
    self.image.layer.cornerRadius = 20.0;
    [self.image.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
