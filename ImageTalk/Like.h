//
//  Like.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/14/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"

@interface Like : JSONModel

@property (assign, nonatomic) int likeCount;
@property (assign, nonatomic) BOOL isLiked;

@end
