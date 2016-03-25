//
//  CommentResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/16/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "ResponseStatus.h"
#import "PostComment.h"

@interface CommentResponse : JSONModel


@property (strong, nonatomic) ResponseStatus  *responseStat;
@property (strong, nonatomic) NSArray <PostComment>  *responseData;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
