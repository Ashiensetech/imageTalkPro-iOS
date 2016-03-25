//
//  AcknowledgementResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/12/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "SocketResponseStat.h"
#import "Acknowledgement.h"

@interface AcknowledgementResponse : JSONModel

@property (strong,nonatomic) SocketResponseStat *responseStat;
@property (strong,nonatomic) Acknowledgement *responseData;

@end
