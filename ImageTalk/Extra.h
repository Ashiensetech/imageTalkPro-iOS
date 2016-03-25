//
//  Extra.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/13/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"

@interface Extra : JSONModel

@property (strong,nonatomic) NSString *nextPageToken;
@property (assign,nonatomic) int wallPost;
@property (assign,nonatomic) int present;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
