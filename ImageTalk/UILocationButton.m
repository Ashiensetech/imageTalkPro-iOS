//
//  UILocationButton.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/1/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "UILocationButton.h"

@implementation UILocationButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    CGRect imageFrame = self.imageView.frame;
    CGRect labelFrame = self.titleLabel.frame;
    
    
    imageFrame.size = CGSizeMake(13.00, 18.00);
    imageFrame.origin.x = self.frame.size.width/2 - (imageFrame.size.width+self.titleLabel.frame.size.width)/2;
    imageFrame.origin.y = self.frame.size.height/2 - self.imageView.frame.size.height/2;
    
    
    labelFrame.origin.x = imageFrame.origin.x +imageFrame.size.width+ 5;

    
    self.imageView.frame = imageFrame;
    self.titleLabel.frame = labelFrame;
    
    
    
}

@end
