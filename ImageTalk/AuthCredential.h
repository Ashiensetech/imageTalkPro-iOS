//
//  AuthCredential.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/5/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "AppCredential.h"

@interface AuthCredential : AppCredential

@property (strong, nonatomic) NSString  *accessToken;

@end
