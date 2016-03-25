//
//  OnlineResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/12/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "SocketResponseStat.h"
#import "TextChat.h"

@interface OnlineResponse : JSONModel

@property (strong,nonatomic) SocketResponseStat *responseStat;
@property (strong,nonatomic) NSArray *responseData;


@end
