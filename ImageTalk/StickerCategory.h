//
//  StickerCategory.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/16/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "Sticker.h"

@protocol StickerCategory

@end

@interface StickerCategory : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *coverPicPath;
@property (strong, nonatomic) NSArray <Sticker> *stickers;

@end
