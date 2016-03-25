//
//  AppCredential.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/5/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "User.h"
#import "Job.h"

@protocol AppCredential

@end

@interface AppCredential : JSONModel

@property (assign, nonatomic) int  id;
@property (strong, nonatomic) NSString <Optional> *textStatus;
@property (strong, nonatomic) User  *user;
@property (strong, nonatomic) Job  *job;
@property (strong, nonatomic) NSString  *phoneNumber;
@property (strong, nonatomic) NSString  *createdDate;

@end
