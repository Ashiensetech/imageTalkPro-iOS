//
//  SocketContactResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 12/1/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "SocketResponseStat.h"
#import "ChatContact.h"

@interface SocketContactResponse : JSONModel

@property (strong,nonatomic) SocketResponseStat *responseStat;
@property (strong,nonatomic) ChatContact *responseData;


@end
