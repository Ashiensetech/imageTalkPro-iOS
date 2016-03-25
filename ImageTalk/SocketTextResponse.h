//
//  SocketTextResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/5/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "SocketResponseStat.h"
#import "Chat.h"
#import "TextChat.h"

@interface SocketTextResponse : JSONModel

@property (strong,nonatomic) SocketResponseStat *responseStat;
@property (strong,nonatomic) TextChat *responseData;

@end
