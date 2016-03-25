//
//  Contact.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/29/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "Contact.h"

@implementation Contact

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
