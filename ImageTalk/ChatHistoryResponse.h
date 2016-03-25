//
//  ChatHistoryResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/11/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "ChatHistory.h"
#import "ResponseStatus.h"

@interface ChatHistoryResponse : JSONModel

@property (strong, nonatomic) ResponseStatus  *responseStat;
@property (strong, nonatomic) NSArray <ChatHistory>  *responseData;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;


@end
