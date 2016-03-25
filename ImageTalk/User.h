//
//  User.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/5/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "Location.h"
#import "Picture.h"

@interface User : JSONModel

@property (strong, nonatomic) NSString <Optional> *id;
@property (strong, nonatomic) NSString <Optional> *firstName;
@property (strong, nonatomic) NSString <Optional> *lastName;
@property (strong, nonatomic) Location  *address;
@property (strong, nonatomic) Picture <Optional> *picPath;
@property (strong, nonatomic) NSString  *createdDate;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;


@end
