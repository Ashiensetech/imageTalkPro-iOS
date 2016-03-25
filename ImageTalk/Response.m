//
//  Response.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/5/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "Response.h"

@implementation Response

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    
    
    return NO;
}


+(BOOL)propertyIsIgnored:(NSString*)propertyName
{
    if([propertyName isEqualToString:@"responseData"])
        return YES;
    return NO;
}


@end
