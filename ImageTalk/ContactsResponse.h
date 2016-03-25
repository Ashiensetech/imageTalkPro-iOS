//
//  ContactsResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/14/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "ResponseStatus.h"
#import "AppCredential.h"

@interface ContactsResponse : JSONModel

@property (strong, nonatomic) ResponseStatus  *responseStat;
@property (strong, nonatomic) NSArray <AppCredential>  *responseData;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;


@end
