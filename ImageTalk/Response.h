//
//  Response.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/5/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "ResponseStatus.h"


@interface Response : JSONModel

@property (strong, nonatomic) ResponseStatus  *responseStat;


+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
