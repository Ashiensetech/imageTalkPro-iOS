//
//  Job.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/2/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "Job.h"

@implementation Job

@synthesize description;

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
