//
//  PostPaginationModel.m
//  Traffic
//
//  Created by Workspace Infotech on 6/23/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "PostPaginationModel.h"


@implementation PostPaginationModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if([propertyName isEqualToString:@"prev_page_url"])
        return YES;
    
    if([propertyName isEqualToString:@"next_page_url"])
        return YES;
    
    return NO;
}




@end
