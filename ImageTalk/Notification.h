//
//  Notification.h
//  ImageTalk
//
//  Created by Workspace Infotech on 6/14/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//


#import "JSONModel.h"
#import "AppCredential.h"
#import "WallPost.h"
@protocol Notification

@end

@interface Notification : JSONModel
@property (assign, nonatomic) int id;
@property (strong ,nonatomic) AppCredential *person;
@property (strong,nonatomic) NSString * actionTag;
@property (strong,nonatomic) NSString * sourceClass;
@property (strong,nonatomic) NSDictionary *source;
//@property (strong,nonatomic) WallPost * source;
@property (assign,nonatomic) BOOL  isRead;
@property (strong, nonatomic) NSString  *createdDate;
@end
