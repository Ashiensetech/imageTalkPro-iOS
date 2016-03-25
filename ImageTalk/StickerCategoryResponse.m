//
//  StickerCategoryResponse.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/10/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "StickerCategoryResponse.h"

@implementation StickerCategoryResponse

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
