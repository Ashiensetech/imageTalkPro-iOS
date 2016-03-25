//
//  ReceiverContactsTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 12/1/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "ReceiverContactsTableViewCell.h"

@implementation ReceiverContactsTableViewCell

- (void)awakeFromNib {
    
    self.containerView.layer.cornerRadius = 20.0;
    [self.containerView.layer setMasksToBounds:YES];
    
   // self.containerView.frame = CGRectInset(self.containerView.frame, -0.5f, -0.5f);
   // self.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
   // self.containerView.layer.borderWidth = 0.5f;
    
    self.image.layer.cornerRadius = 16.0;
    [self.image.layer setMasksToBounds:YES];
    
    self.image.backgroundColor = [UIColor orangeColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
