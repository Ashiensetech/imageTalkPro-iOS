//
//  CustomUIButton.m
//  Doorman
//
//  Created by NS Rahman on 8/2/15.
//  Copyright (c) 2015 WSIT. All rights reserved.
//

#import "CustomUIButton.h"

@implementation CustomUIButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super imageRectForContentRect:contentRect];
    frame.origin.x = CGRectGetMaxX(contentRect) - CGRectGetWidth(frame) -  self.imageEdgeInsets.right -10+ self.imageEdgeInsets.left;
    return frame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super titleRectForContentRect:contentRect];
    frame.origin.x = CGRectGetWidth(self.frame)/2 - CGRectGetWidth(frame)/2;
    return frame;
}


@end
