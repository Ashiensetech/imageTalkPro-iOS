//
//  MediaPath.h
//  ImageTalk
//
//  Created by Workspace Infotech on 1/15/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "PictureDetails.h"

@interface MediaPath : JSONModel

@property (strong, nonatomic) PictureDetails <Optional>  *original;
@property (strong, nonatomic) NSArray <PictureDetails>  *thumb;
@property (strong,nonatomic) NSString <Optional> *path;
@property (strong,nonatomic) NSString <Optional> *type;
@property (strong,nonatomic) NSString <Optional> *size;
@property (strong,nonatomic) NSString <Optional> *resulation;
@property (strong,nonatomic) NSString <Optional> *coverPic;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
