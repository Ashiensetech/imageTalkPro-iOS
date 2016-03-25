//
//  WallPost.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/5/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "AppCredential.h"
#import "Places.h"
#import "PostComment.h"
#import "Picture.h"
#import "Liker.h"

@protocol WallPost

@end

@interface WallPost : JSONModel

@property (assign, nonatomic) int  id;
@property (assign, nonatomic) int  type;
@property (strong, nonatomic) NSString  *description;
@property (strong, nonatomic) AppCredential  *owner;
@property (strong, nonatomic) NSString  *picPath;
@property (strong, nonatomic) NSArray <AppCredential>  *tagList;
@property (assign, nonatomic) int  likeCount;
@property (assign, nonatomic) int  commentCount;
@property (assign, nonatomic) int  tagCount;
@property (strong, nonatomic) NSArray <PostComment>  *comments;
@property (strong, nonatomic) NSArray <Liker>  *likerList;
@property (strong, nonatomic) Places  *places;
@property (strong, nonatomic) NSString  *createdDate;
@property (assign, nonatomic) BOOL isLiked;
@property (assign, nonatomic) BOOL isFavorite;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;



@end
