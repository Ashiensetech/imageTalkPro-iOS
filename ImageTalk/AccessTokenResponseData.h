//
//  AccessTokenResponseData.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/13/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "AuthCredential.h"
#import "Extra.h"


@interface AccessTokenResponseData : JSONModel

@property (strong, nonatomic) AuthCredential  *authCredential;
@property (strong, nonatomic) NSArray <AppCredential>  *contacts;
@property (strong, nonatomic) Extra  *extra;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;


@end
