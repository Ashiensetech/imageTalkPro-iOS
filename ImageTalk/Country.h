//
//  Country.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/5/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"

@protocol Country

@end

@interface Country : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString  *iso;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSString  *niceName;
@property (strong, nonatomic) NSString  *iso3;
@property (assign, nonatomic) int  numcode;
@property (assign, nonatomic) int  phoneCode;
@property (assign, nonatomic) BOOL status;


+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;



@end
