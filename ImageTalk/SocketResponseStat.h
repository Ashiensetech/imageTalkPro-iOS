//
//  SocketResponseStat.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/5/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"

@interface SocketResponseStat : JSONModel

@property (assign,nonatomic) BOOL status;
@property (strong,nonatomic) NSString *tag;
@property (strong,nonatomic) NSString *chatId;
@property (strong,nonatomic) NSString *msg;

@end
