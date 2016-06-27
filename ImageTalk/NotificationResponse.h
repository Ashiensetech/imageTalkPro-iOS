//
//  NotificationResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 6/14/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "ResponseStatus.h"
#import "Notification.h"

@interface NotificationResponse : JSONModel
@property (strong, nonatomic) ResponseStatus  *responseStat;
@property (strong, nonatomic) NSArray <Notification>  *responseData;

@end
