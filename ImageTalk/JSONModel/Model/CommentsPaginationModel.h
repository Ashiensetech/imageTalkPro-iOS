//
//  CommentsPaginationModel.h
//  Traffic
//
//  Created by Workspace Infotech on 6/25/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "PostCommentsModel.h"

@interface CommentsPaginationModel : JSONModel

@property (strong, nonatomic) NSArray<PostCommentsModel>* data;

@end
