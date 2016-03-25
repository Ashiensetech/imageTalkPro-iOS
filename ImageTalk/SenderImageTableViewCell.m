//
//  SenderImageTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/16/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "SenderImageTableViewCell.h"

@implementation SenderImageTableViewCell

- (void)awakeFromNib {
    
    self.containerView.layer.cornerRadius = 20.0;
    [self.containerView.layer setMasksToBounds:YES];
    
    self.image.layer.cornerRadius = 20.0;
    [self.image.layer setMasksToBounds:YES];
}

- (void) startTimer:(NSDate*) startTime
{
    if (!self.isDeleted) {
        
        if (self.timer)
            [self.timer invalidate];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(calculateTimer:) userInfo:startTime repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
