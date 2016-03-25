//
//  PictureDetails.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "PictureSize.h"

@protocol PictureDetails

@end

@interface PictureDetails : JSONModel

@property (strong, nonatomic) NSString  *path;
@property (strong, nonatomic) NSString  *type;
@property (strong, nonatomic) PictureSize  *size;



@end
