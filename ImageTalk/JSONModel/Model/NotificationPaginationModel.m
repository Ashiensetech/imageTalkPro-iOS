//
//  NotificationPaginationModel.m
//  Traffic
//
//  Created by Workspace Infotech on 6/29/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "NotificationPaginationModel.h"

@implementation NotificationPaginationModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if([propertyName isEqualToString:@"prev_page_url"])
        return YES;
    
    return NO;
}

@end
