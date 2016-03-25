//
//  AccessTokenResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/13/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "ResponseStatus.h"
#import "AccessTokenResponseData.h"

@interface AccessTokenResponse : JSONModel


@property (strong, nonatomic) ResponseStatus  *responseStat;
@property (strong, nonatomic) AccessTokenResponseData  *responseData;


+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
