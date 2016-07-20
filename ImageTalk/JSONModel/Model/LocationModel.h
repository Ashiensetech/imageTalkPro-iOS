//
//  LocationModel.h
//  Traffic
//
//  Created by Workspace Infotech on 6/23/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"

@protocol LocationModel

@end


@interface LocationModel : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString  *name;
@property (assign, nonatomic) float lon;
@property (assign, nonatomic) float lat;
@property (strong, nonatomic) NSString  *createdDate;



@end
