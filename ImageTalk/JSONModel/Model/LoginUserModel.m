//
//  LoginUserModel.m
//  Traffic
//
//  Created by Workspace Infotech on 6/29/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "LoginUserModel.h"

@implementation LoginUserModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if([propertyName isEqualToString:@"fbId"])
        return YES;
    
    return NO;
}

@end
