//
//  ReceiverSingleTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 12/15/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "ReceiverSingleTableViewCell.h"

@implementation ReceiverSingleTableViewCell

- (void)awakeFromNib {
    
    self.containerView.layer.cornerRadius = 15.0;
    [self.containerView.layer setMasksToBounds:YES];
    
   // self.containerView.frame = CGRectInset(self.containerView.frame, -0.5f, -0.5f);
   // self.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
   // self.containerView.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
