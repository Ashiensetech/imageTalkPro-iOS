//
//  TimerAccess.m
//  ImageTalk
//
//  Created by Workspace Infotech on 1/7/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import "TimerAccess.h"

@implementation TimerAccess

static TimerAccess *sharedInstance = nil;

+(TimerAccess*)getSharedInstance{
    
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
    
    }
    
    return sharedInstance;
}

- (void) initial
{
    self.app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) timerIntilaizeWithChatId:(NSString*) chatId duration:(int) value
{
    if (![self.app.timers objectForKey:chatId]) {
        
        
        NSTimer *timer = [[NSTimer alloc]init];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(calculateTimer:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:value],@"duration",chatId,@"chatid",[NSDate dateWithTimeIntervalSinceNow:1],@"time", nil] repeats:YES];
        [timer fire];
        [self.app.timers setObject:timer forKey:chatId];
        
    }
}

- (BOOL) isChatId:(NSString*) chatId
{
    if ([self.app.timers objectForKey:chatId])
    {
        NSLog(@"%@",self.app.timers);
        return true;
    }
    else
    {
        return false;
    }

}

- (void) timerRemoveWithChatId:(NSString*) chatId
{
    [self.app.timers removeObjectForKey:chatId];
}

- (void)calculateTimer : (NSTimer *)timer
{
    NSTimeInterval interval = [(NSDate*)[[timer userInfo] objectForKey:@"time"] timeIntervalSinceNow];
    interval = (-1 * interval);
    
    if ([[[timer userInfo] objectForKey:@"duration"] integerValue] < interval)
    {
        [self.delegate timerFinishWithChatId:(NSString*)[[timer userInfo] objectForKey:@"chatid"]];
        [timer invalidate];
    }
    else
    {
        [self.delegate timerTickWithChatId:(NSString*)[[timer userInfo] objectForKey:@"chatid"] interval:[[[timer userInfo] objectForKey:@"duration"] integerValue]-interval];
    }
    
    
}



@end
