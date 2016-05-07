//
//  AppDelegate.h
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccessTokenResponse.h"
#import "AppCredential.h"
#import "tcpSocketChat.h"
#import "AudioController.h"
#import "SoundManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,tcpSocketChatDelegate>

@property (strong, nonatomic) AudioController *audioController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *contacts;
@property (strong, nonatomic) AccessTokenResponse *response;
@property (strong, nonatomic) AuthCredential  *authCredential;
@property (strong, nonatomic) NSString  *userPic;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString  *textStatus;
@property (assign, nonatomic) int  wallpost;
@property (assign) SystemSoundID pewPewSound;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSMutableDictionary* timers;

@end

