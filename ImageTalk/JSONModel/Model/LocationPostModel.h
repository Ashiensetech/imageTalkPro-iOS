//
//  LocationPostModel.h
//  Traffic
//
//  Created by Workspace Infotech on 8/13/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"

@interface LocationPostModel : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString  *name;
@property (assign, nonatomic) float lon;
@property (assign, nonatomic) float lat;

@end
