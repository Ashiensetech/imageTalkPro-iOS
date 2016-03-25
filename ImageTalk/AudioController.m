//
//  AudioController.m
//  ATBasicSounds
//
//  Created by Audrey M Tam on 22/03/2014.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

#import "AudioController.h"
@import AVFoundation;

@interface AudioController () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (assign) BOOL backgroundMusicPlaying;
@property (assign) BOOL backgroundMusicInterrupted;
@property (assign) SystemSoundID pewPewSound;

@end

@implementation AudioController

#pragma mark - Public

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureAudioSession];
        [self configureSystemSound];
    }
    return self;
}


- (void)playSystemSound {
    AudioServicesPlaySystemSound(self.pewPewSound);
}

#pragma mark - Private

- (void) configureAudioSession {
    self.audioSession = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    if ([self.audioSession isOtherAudioPlaying]) { // mix sound effects with music already playing
        [self.audioSession setCategory:AVAudioSessionCategorySoloAmbient error:&setCategoryError];
       
    } else {
        [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    }
    if (setCategoryError) {
        NSLog(@"Error setting category! %ld", (long)[setCategoryError code]);
    }
}



- (void)configureSystemSound {
   
	NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"mp3"];
	NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &_pewPewSound);
}

#pragma mark - AVAudioPlayerDelegate methods

- (void) audioPlayerBeginInterruption: (AVAudioPlayer *) player {
    
    
}

- (void) audioPlayerEndInterruption: (AVAudioPlayer *) player withOptions:(NSUInteger) flags{
 
    
}

@end
