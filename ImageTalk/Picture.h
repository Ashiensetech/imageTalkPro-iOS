//
//  Picture.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "PictureDetails.h"

@interface Picture : JSONModel

@property (strong, nonatomic) PictureDetails  *original;
@property (strong, nonatomic) NSArray <PictureDetails>  *thumb;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
