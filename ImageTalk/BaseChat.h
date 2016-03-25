//
//  BaseChat.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/5/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "AppCredential.h"

@interface BaseChat : JSONModel

@property (assign,nonatomic) int id;
@property (assign,nonatomic) int type;
@property (assign,nonatomic) int to;
@property (assign,nonatomic) int from;
@property (assign,nonatomic) BOOL recevice;
@property (assign,nonatomic) BOOL send;
@property (strong,nonatomic) NSString <Optional> *chatId;
@property (strong,nonatomic) NSString <Optional> *tmpChatId;
@property (strong,nonatomic) AppCredential <Optional> * appCredential;
@property (strong,nonatomic) NSString <Ignore> *extra;
@property (strong,nonatomic) NSString <Optional> *createdDate;

@end
