//
//  TimerAccess.h
//  ImageTalk
//
//  Created by Workspace Infotech on 1/7/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol TimeAccessDelegate <NSObject>

@required
-(void)timerTickWithChatId:(NSString*) chatId interval:(int) interval;
-(void)timerFinishWithChatId:(NSString*) chatId;
@end

@interface TimerAccess : NSObject

@property (nonatomic,assign) id<TimeAccessDelegate> delegate;
@property (nonatomic ,strong) AppDelegate *app;

+(TimerAccess*)getSharedInstance;

- (void) initial;
- (void) timerIntilaizeWithChatId:(NSString*) chatId duration:(int) value;
- (void) timerRemoveWithChatId:(NSString*) chatId;
- (BOOL) isChatId:(NSString*) chatId;

@end
