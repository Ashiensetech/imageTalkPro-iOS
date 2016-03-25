//
//  Chat.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/6/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "Picture.h"
#import "ChatExtra.h"
#import "MediaPath.h"

@protocol Chat

@end

@interface Chat : JSONModel

@property (assign,nonatomic) long id;
@property (assign,nonatomic) int type;
@property (assign,nonatomic) int to;
@property (assign,nonatomic) int from;
@property (assign,nonatomic) BOOL readStatus;
@property (strong,nonatomic) NSString  *chatId;
@property (strong,nonatomic) NSString  *chatText;
@property (strong,nonatomic) ChatExtra <Optional> *extra;
@property (strong,nonatomic) MediaPath *mediaPath;
@property (strong,nonatomic) NSString *createdDate;


+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
