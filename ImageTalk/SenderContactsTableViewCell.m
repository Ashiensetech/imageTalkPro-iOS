//
//  SenderContactsTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 12/1/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "SenderContactsTableViewCell.h"

@implementation SenderContactsTableViewCell

- (void)awakeFromNib {
    
    self.containerView.layer.cornerRadius = 20.0;
    [self.containerView.layer setMasksToBounds:YES];
    
    self.image.layer.cornerRadius = 16.0;
    [self.image.layer setMasksToBounds:YES];
    
    self.image.backgroundColor = [UIColor orangeColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
