//
//  UserModel.h
//  Traffic
//
//  Created by Workspace Infotech on 6/24/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"



@interface UserModel : JSONModel

@property (assign, nonatomic) int uId;
@property (strong, nonatomic) NSString  *fullName;
@property (strong, nonatomic) NSString  *profilePic;
@property (strong, nonatomic) NSString  *email;
@property (strong, nonatomic) NSString  *dob;
@property (strong, nonatomic) NSString  *about;
@property (strong, nonatomic) NSString  *fId;
@property (strong, nonatomic) NSString  *username;
@property (assign, nonatomic) int type;

+(BOOL)propertyIsOptional:(NSString*)propertyName;


@end
