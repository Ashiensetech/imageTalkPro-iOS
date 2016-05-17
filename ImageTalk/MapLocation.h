//
//  AppleMapLoction.h
//  ImageTalk
//
//  Created by Workspace Infotech on 5/13/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface MapLocation : JSONModel
@property (assign,nonatomic) BOOL isCurrentLocation;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString <Optional> *phoneNumber;
@property (strong,nonatomic) NSString *placemark;
@property (strong,nonatomic) NSString <Optional> *timeZone;
@property (strong,nonatomic) NSString <Optional> *url;

@end
