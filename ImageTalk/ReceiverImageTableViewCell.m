//
//  ReceiverImageTableViewCell.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/16/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "ReceiverImageTableViewCell.h"

@implementation ReceiverImageTableViewCell

- (void)awakeFromNib {
    
    self.containerView.layer.cornerRadius = 20.0;
    [self.containerView.layer setMasksToBounds:YES];
    
   // self.containerView.frame = CGRectInset(self.containerView.frame, -0.5f, -0.5f);
   // self.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
   // self.containerView.layer.borderWidth = 0.5f;
    
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

- (void)calculateTimer:(NSTimer*)theTimer
{
    NSTimeInterval interval = [(NSDate*)[theTimer userInfo] timeIntervalSinceNow];
    interval = (-1 * interval);
    
    if (self.timerValue < interval)
    {
        self.timerLabel.text  = [NSString stringWithFormat:@"Photo Has Been Removed"];
        self.timerLabel.textColor = [UIColor redColor];
        self.isDeleted = YES;
        [self.timer invalidate];
    }
    else
    {
        self.timerLabel.text  = [NSString stringWithFormat:@"Time left :%d Seconds", self.timerValue-(int)interval];
    }
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
