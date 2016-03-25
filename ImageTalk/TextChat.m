//
//  TextChat.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/5/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "TextChat.h"

@implementation TextChat

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if([propertyName isEqualToString:@""])
        return YES;
    
    return NO;
}


+(BOOL)propertyIsIgnored:(NSString*)propertyName
{
    if([propertyName isEqualToString:@"extra"])
        return YES;
    
    return NO;
}

@end
