//
//  SocketVideoResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 1/15/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "SocketResponseStat.h"
#import "ChatVideo.h"

@interface SocketVideoResponse : JSONModel

@property (strong,nonatomic) SocketResponseStat *responseStat;
@property (strong,nonatomic) ChatVideo *responseData;


@end
