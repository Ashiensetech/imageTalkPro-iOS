//
//  GooglePlacesArray.h
//  ImageTalk
//
//  Created by Workspace Infotech on 12/31/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "GooglePlaces.h"

@interface GooglePlacesArray : JSONModel


@property (strong, nonatomic) NSArray <GooglePlaces>  *results;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
