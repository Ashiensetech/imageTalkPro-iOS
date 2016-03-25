//
//  ChatResponse.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/6/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "ChatResponse.h"

@implementation ChatResponse

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if([propertyName isEqualToString:@""])
        return YES;
    
    return NO;
}


+(BOOL)propertyIsIgnored:(NSString*)propertyName
{
    
    return NO;
}

@end
