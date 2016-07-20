//
//  LocationArrayModel.h
//  Traffic
//
//  Created by Workspace Infotech on 6/24/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "LocationModel.h"

@interface LocationArrayModel : JSONModel

@property (strong, nonatomic) NSArray<LocationModel>* data;

@end
