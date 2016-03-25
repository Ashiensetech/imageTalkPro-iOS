//
//  PostModel.h
//  Traffic
//
//  Created by Workspace Infotech on 6/23/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "PostLocationModel.h"
#import "PostCommentsModel.h"
#import "PostWeightModel.h"
#import "UserModel.h"


@protocol PostModel

@end

@interface PostModel : JSONModel

@property (assign, nonatomic) int id;
@property (assign, nonatomic) int district_id;
@property (strong, nonatomic) NSString* description;
@property (strong, nonatomic) NSString *createdDate;
@property (strong, nonatomic) NSArray<PostCommentsModel>* comment;
@property (assign, nonatomic) int verifiedCount;
@property (assign, nonatomic) int disputeCount;
@property (strong, nonatomic) UserModel* user;
@property (strong, nonatomic) PostLocationModel* f_loc;
@property (strong, nonatomic) PostLocationModel* t_loc;










@end
