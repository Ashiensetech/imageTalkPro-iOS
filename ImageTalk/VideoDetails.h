//
//  VideoDetails.h
//  ImageTalk
//
//  Created by Workspace Infotech on 1/13/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import "BaseChat.h"

@interface VideoDetails : JSONModel

@property (strong,nonatomic) NSString <Optional> *path;
@property (strong,nonatomic) NSString <Optional> *type;
@property (strong,nonatomic) NSString <Optional> *size;
@property (strong,nonatomic) NSString <Optional> *resulation;
@property (strong,nonatomic) NSString <Optional> *coverPic;


@end
