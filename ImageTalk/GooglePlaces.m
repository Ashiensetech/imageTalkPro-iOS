//
//  GooglePlaces.m
//  ImageTalk
//
//  Created by Workspace Infotech on 12/31/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "GooglePlaces.h"

@implementation GooglePlaces

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    
    return YES;
    
}

+ (JSONKeyMapper*)keyMapper {
    
    NSDictionary *map = @{ @"geometry.location.lat": @"lat",
                           @"geometry.location.lng"  : @"lng",
                           @"vicinity"  : @"formattedAddress",
                           @"place_id"  : @"placeId",
                           };
    
    return [[JSONKeyMapper alloc] initWithDictionary:map];
}

@end
