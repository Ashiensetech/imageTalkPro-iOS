//
//  ReceiverImageTableViewCell.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/16/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiverImageTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIButton *click;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *effect;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *startTime;
@property (assign, nonatomic) BOOL isDeleted;
@property (assign, nonatomic) BOOL isRunning;
@property (assign, nonatomic) int timerValue;
@property (weak, nonatomic)  UIImage *imageValue;

- (void)startTimer:(NSDate*) startTime;
- (void)calculateTimer:(NSTimer*)theTimer;

@end
