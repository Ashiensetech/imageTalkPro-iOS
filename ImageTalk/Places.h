//
//  Places.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/26/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "Location.h"

@protocol Places

@end

@interface Places : Location

@property (strong,nonatomic) NSString *placeId;
@property (strong,nonatomic) NSString *icon;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *googlePlaceId;
@property (assign,nonatomic) float rating;

@end
