//
//  GooglePlaces.h
//  ImageTalk
//
//  Created by Workspace Infotech on 12/31/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "Places.h"


@protocol GooglePlaces

@end

@interface GooglePlaces : Places

+(BOOL)propertyIsOptional:(NSString*)propertyName;

@end
