//
//  PostCreateModel.h
//  Traffic
//
//  Created by Workspace Infotech on 6/26/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"

@interface PostCreateModel : JSONModel

@property (assign, nonatomic) BOOL isLogin;
@property (assign, nonatomic) BOOL status;
@property (strong, nonatomic) NSString  *message;
@property (assign, nonatomic) BOOL state;

@end
