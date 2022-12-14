//
//  Tag.h
//  ImageTalk
//
//  Created by Workspace Infotech on 5/11/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//
#import "JSONModel.h"
#import "AppCredential.h"
#import <Foundation/Foundation.h>

@protocol Tag

@end
@interface Tag : JSONModel

@property (strong, nonatomic) AppCredential *tagId;
@property (strong, nonatomic) NSString <Optional> *originX;
@property (strong, nonatomic) NSString <Optional> *originY;
@property (strong, nonatomic) NSString <Optional> *tagMessage;



@end
