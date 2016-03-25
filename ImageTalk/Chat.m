//
//  Chat.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/6/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "Chat.h"

@implementation Chat

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if([propertyName isEqualToString:@"extra"])
        return YES;
    
    return NO;
}


+(BOOL)propertyIsIgnored:(NSString*)propertyName
{
    
    return NO;
}

@end
