//
//  PostCommentsModel.h
//  Traffic
//
//  Created by Workspace Infotech on 6/23/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "UserModel.h"

@protocol PostCommentsModel

@end

@interface PostCommentsModel : JSONModel

@property (assign, nonatomic) int id;
@property (assign, nonatomic) int post_id;
@property (assign, nonatomic) int  u_id;
@property (strong, nonatomic) NSString  *comment_text;
@property (strong, nonatomic) NSString *createdDate;
@property (strong, nonatomic) UserModel* user;


@end
