//
//  DateTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 1/21/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import "DateTableViewCell.h"

@implementation DateTableViewCell

- (void)awakeFromNib {
    
    self.containerView.layer.cornerRadius = 10.0;
    [self.containerView.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
