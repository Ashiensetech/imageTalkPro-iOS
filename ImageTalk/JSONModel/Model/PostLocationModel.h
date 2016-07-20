//
//  PostLocationModel.h
//  Traffic
//
//  Created by Workspace Infotech on 6/26/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"

@interface PostLocationModel : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString  *name;
@property (assign, nonatomic) float lon;
@property (assign, nonatomic) float lat;

@end
