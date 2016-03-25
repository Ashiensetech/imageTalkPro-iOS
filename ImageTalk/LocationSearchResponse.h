//
//  LocationSearchResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/16/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "ResponseStatus.h"
#import "GooglePlaces.h"


@interface LocationSearchResponse : JSONModel

//@property (strong, nonatomic) ResponseStatus  *responseStat;
//@property (strong, nonatomic) LocationSearchData  *responseData;

@property (strong, nonatomic) NSArray <GooglePlaces>  *results;
@property (strong, nonatomic) NSString <Optional> *next_page_token;


+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
