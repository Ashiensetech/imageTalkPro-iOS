//
//  UIPhotoChoseButton.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/1/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "UIPhotoChoseButton.h"

@implementation UIPhotoChoseButton

- (void)layoutSubviews
{
    // Allow default layout, then adjust image and label positions
    [super layoutSubviews];
    
    
    
    CGRect imageFrame = self.imageView.frame;
    CGRect labelFrame = self.titleLabel.frame;
    
    
    imageFrame.size = CGSizeMake(32.00, 32.00);
    imageFrame.origin.x = 30;
    imageFrame.origin.y = self.frame.size.height/2 - self.imageView.frame.size.height/2;
    
    
    
    
    labelFrame.origin.x = self.frame.size.width/2 - self.titleLabel.frame.size.width/2;
    
    
    
    self.imageView.frame = imageFrame;
    self.titleLabel.frame = labelFrame;
    
    //self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    
}


@end
