//
//  PostWeightModel.h
//  Traffic
//
//  Created by NS Rahman on 6/27/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"


@interface PostWeightModel : JSONModel

@property (assign, nonatomic) BOOL status;
@property (assign, nonatomic) int countVerified;
@property (assign, nonatomic) int countDispute;

@end
