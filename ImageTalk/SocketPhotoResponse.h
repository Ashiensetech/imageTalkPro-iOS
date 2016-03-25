//
//  SocketPhotoResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/16/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "SocketResponseStat.h"
#import "ChatPhoto.h"

@interface SocketPhotoResponse : JSONModel

@property (strong,nonatomic) SocketResponseStat *responseStat;
@property (strong,nonatomic) ChatPhoto *responseData;

@end
