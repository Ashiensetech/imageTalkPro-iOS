//
//  Sticker.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/16/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"

@protocol Sticker

@end

@interface Sticker : JSONModel

@property (assign, nonatomic) int id;
@property (assign, nonatomic) int stickerCategoryId;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *path;

@end
