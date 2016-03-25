//
//  LocationSearchData.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/26/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "Places.h"
#import "Extra.h"

@interface LocationSearchData : JSONModel

@property (strong, nonatomic) NSArray <Places>  *places;
@property (strong, nonatomic) Extra  *extra;


+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
