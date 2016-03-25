//
//  ChatVideo.h
//  ImageTalk
//
//  Created by Workspace Infotech on 1/13/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import "BaseChat.h"
#import "VideoDetails.h"

@interface ChatVideo : BaseChat

@property (strong,nonatomic) NSString *caption;
@property (strong,nonatomic) VideoDetails *video;


+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
