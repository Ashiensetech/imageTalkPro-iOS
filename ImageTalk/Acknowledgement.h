//
//  Acknowledgement.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/5/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "AppCredential.h"

@interface Acknowledgement : JSONModel

@property (assign,nonatomic) int id;
@property (strong,nonatomic) NSString <Optional> *chatId;
@property (strong,nonatomic) NSString <Optional> *tmpChatId;
@property (strong,nonatomic) NSString <Optional> *lastSeen;
@property (strong,nonatomic) AppCredential * appCredential;
@property (assign,nonatomic) BOOL isRead;
@property (assign,nonatomic) BOOL isOnline;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;


@end
