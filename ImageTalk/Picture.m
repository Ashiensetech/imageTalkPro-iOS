//
//  Picture.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "Picture.h"

@implementation Picture

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if([propertyName isEqualToString:@"original"])
        return YES;
    
    if([propertyName isEqualToString:@"thumb"])
        return YES;

    
    
    return NO;
}


+(BOOL)propertyIsIgnored:(NSString*)propertyName
{
    return NO;
}


@end
