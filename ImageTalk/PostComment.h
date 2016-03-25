//
//  PostComment.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/5/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "AppCredential.h"

@protocol PostComment

@end

@interface PostComment : JSONModel

@property (assign, nonatomic) int  id;
@property (strong, nonatomic) NSString  *comment;
@property (assign, nonatomic) int  postId;
@property (strong, nonatomic) AppCredential  *commenter;
@property (strong, nonatomic) NSString  *picPath;
@property (strong, nonatomic) NSString  *createdDate;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
