//
//  StickerCategoryResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/10/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "ResponseStatus.h"
#import "StickerCategory.h"

@interface StickerCategoryResponse : JSONModel

@property (strong, nonatomic) ResponseStatus  *responseStat;
@property (strong, nonatomic) NSArray <StickerCategory>  *responseData;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;


@end
