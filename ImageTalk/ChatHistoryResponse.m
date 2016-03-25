//
//  ChatHistoryResponse.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/11/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "ChatHistoryResponse.h"

@implementation ChatHistoryResponse

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
