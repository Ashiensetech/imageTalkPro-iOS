//
//  ResponseStatus.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/5/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "AppCredential.h"

@interface ResponseStatus : JSONModel

@property (assign, nonatomic) BOOL status;
@property (assign, nonatomic) BOOL isLogin;
@property (strong, nonatomic) NSString  *msg;


@end
