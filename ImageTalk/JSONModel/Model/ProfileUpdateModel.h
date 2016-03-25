//
//  ProfileUpdateModel.h
//  Traffic
//
//  Created by Workspace Infotech on 6/29/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "LoginUserModel.h"

@interface ProfileUpdateModel : JSONModel

@property (assign, nonatomic) BOOL isLogin;
@property (assign, nonatomic) BOOL status;
@property (strong, nonatomic) NSString  *message;
@property (strong, nonatomic) LoginUserModel* data;

@end
