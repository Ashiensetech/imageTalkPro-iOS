//
//  Liker.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/8/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "AppCredential.h"


@protocol Liker

@end

@interface Liker : AppCredential


@property (assign, nonatomic) int  likeId;
@property (strong, nonatomic) NSString  *likedDate;


@end
