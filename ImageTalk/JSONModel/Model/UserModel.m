//
//  UserModel.m
//  Traffic
//
//  Created by Workspace Infotech on 6/24/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if([propertyName isEqualToString:@"fId"])
        return YES;
    
    return NO;
}

@end
