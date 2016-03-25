//
//  StickerResponse.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/16/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "StickerResponse.h"

@implementation StickerResponse

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
