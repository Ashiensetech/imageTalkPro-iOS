//
//  LoginUserModel.h
//  Traffic
//
//  Created by Workspace Infotech on 6/29/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"

@interface LoginUserModel : JSONModel

@property (assign, nonatomic) int uId;
@property (strong, nonatomic) NSString  *fbId;
@property (strong, nonatomic) NSString  *userName;
@property (strong, nonatomic) NSString  *fullName;
@property (strong, nonatomic) NSString  *email;
@property (strong, nonatomic) NSString  *dob;
@property (strong, nonatomic) NSString  *about;
@property (strong, nonatomic) NSString  *profilePic;
@property (assign, nonatomic) int type;

+(BOOL)propertyIsOptional:(NSString*)propertyName;



@end
