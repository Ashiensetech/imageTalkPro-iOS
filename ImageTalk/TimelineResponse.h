//
//  TimelineResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/8/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "ResponseStatus.h"
#import "WallPost.h"


@interface TimelineResponse : JSONModel

@property (strong, nonatomic) ResponseStatus  *responseStat;
@property (strong, nonatomic) NSArray <WallPost>  *responseData;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
