//
//  CreatePostResponse.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "CreatePostResponse.h"

@implementation CreatePostResponse

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if([propertyName isEqualToString:@"responseData"])
        return YES;
    
    return NO;
}


+(BOOL)propertyIsIgnored:(NSString*)propertyName
{
    
    return NO;
}

@end
