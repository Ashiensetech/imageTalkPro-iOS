//
//  Extra.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/13/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "Extra.h"

@implementation Extra

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if([propertyName isEqualToString:@"wallPost"])
        return YES;
    
    if([propertyName isEqualToString:@"present"])
        return YES;
    
    if([propertyName isEqualToString:@"nextPageToken"])
        return YES;
    
    return NO;
}


+(BOOL)propertyIsIgnored:(NSString*)propertyName
{
    
    return NO;
}

@end
