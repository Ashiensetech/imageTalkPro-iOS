//
//  LikesResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/28/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "ResponseStatus.h"
#import "Liker.h"


@interface LikesResponse : JSONModel

@property (strong, nonatomic) ResponseStatus  *responseStat;
@property (strong, nonatomic) NSArray <Liker>  *responseData;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
