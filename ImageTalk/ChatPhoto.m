//
//  ChatPhoto.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/16/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "ChatPhoto.h"

@implementation ChatPhoto

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    
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
