//
//  WallPost.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/5/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "WallPost.h"

@implementation WallPost

@synthesize description;

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if([propertyName isEqualToString:@"comments"])
        return YES;
    
    if([propertyName isEqualToString:@"tagList"])
        return YES;
    
    if([propertyName isEqualToString:@"likerList"])
        return YES;
    
    
    if([propertyName isEqualToString:@"description"])
        return YES;
    
    return NO;
}


+(BOOL)propertyIsIgnored:(NSString*)propertyName
{
    
    return NO;
}

@end
