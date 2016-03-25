//
//  ChatPhoto.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/16/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "BaseChat.h"
#import "Picture.h"

@interface ChatPhoto : BaseChat


@property (strong,nonatomic) NSString *caption;
@property (strong,nonatomic) NSString *base64Img;
@property (strong,nonatomic) Picture *pictures;
@property (assign,nonatomic) int timer;
@property (assign,nonatomic) BOOL tookSnapShot;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
