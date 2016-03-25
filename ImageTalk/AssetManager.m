//
//  AssetManager.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/6/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "AssetManager.h"

@implementation AssetManager

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
