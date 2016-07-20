//
//  NotificationPaginationModel.h
//  Traffic
//
//  Created by Workspace Infotech on 6/29/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "NotificationModel.h"



@interface NotificationPaginationModel : JSONModel

@property (assign, nonatomic) int total;
@property (assign, nonatomic) int per_page;
@property (assign, nonatomic) int current_page;
@property (assign, nonatomic) int last_page;
@property (strong, nonatomic) NSString  *next_page_url;
@property (strong, nonatomic) NSString  *prev_page_url;
@property (assign, nonatomic) int from;
@property (assign, nonatomic) int to;
@property (strong, nonatomic) NSArray<NotificationModel>* data;



+(BOOL)propertyIsOptional:(NSString*)propertyName;

@end
