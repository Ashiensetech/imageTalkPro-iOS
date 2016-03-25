//
//  ChatExtra.m
//  ImageTalk
//
//  Created by Workspace Infotech on 12/1/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "ChatExtra.h"

@implementation ChatExtra

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    
    if([propertyName isEqualToString:@"id"])
        return YES;
    
    if([propertyName isEqualToString:@"contactId"])
        return YES;
    
    if([propertyName isEqualToString:@"favorites"])
        return YES;
    
    if([propertyName isEqualToString:@"isBlock"])
        return YES;
    
    if([propertyName isEqualToString:@"rating"])
        return YES;
    
    if([propertyName isEqualToString:@"lat"])
        return YES;
    
    if([propertyName isEqualToString:@"lng"])
        return YES;
    
    if([propertyName isEqualToString:@"type"])
        return YES;
    
    if([propertyName isEqualToString:@"recevice"])
        return YES;
    
    if([propertyName isEqualToString:@"send"])
        return YES;
    
    if([propertyName isEqualToString:@"timer"])
        return YES;
    
    if([propertyName isEqualToString:@"tookSnapShot"])
        return YES;

    
    return NO;
}


+(BOOL)propertyIsIgnored:(NSString*)propertyName
{
    
    return NO;
}

@end
