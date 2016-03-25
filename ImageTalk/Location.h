//
//  Location.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/5/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"

@protocol Location

@end

@interface Location : JSONModel

@property (assign, nonatomic) int id;
@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lng;
@property (strong, nonatomic) NSString  *formattedAddress;
@property (strong, nonatomic) NSString  *countryName;

@end
