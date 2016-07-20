//
//  NotificationModel.h
//  Traffic
//
//  Created by Workspace Infotech on 6/23/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"


@protocol NotificationModel

@end

@interface NotificationModel : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* msg;
@property (assign, nonatomic) int type;
@property (assign, nonatomic) int createdBy;
@property (strong, nonatomic) NSString *createdTime;
@property (assign, nonatomic) BOOL check;


@end
