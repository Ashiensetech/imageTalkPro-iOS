//
//  LocationSearchData.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/26/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "LocationSearchData.h"

@implementation LocationSearchData

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
