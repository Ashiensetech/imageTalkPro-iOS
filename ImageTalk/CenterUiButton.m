//
//  CenterUiButton.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "CenterUiButton.h"

@implementation CenterUiButton

-(void) awakeFromNib{
    CGRect imageFrame = self.imageView.frame;
    CGRect labelFrame = self.titleLabel.frame;
    
    
    imageFrame.origin.x = self.frame.size.width/2 - self.imageView.frame.size.width/2;
    imageFrame.origin.y = self.frame.size.height/2 - self.imageView.frame.size.height/2 - 5 ;
    imageFrame.size = CGSizeMake(32.00, 32.00);
    
    
    
    labelFrame.size.width = self.frame.size.width;
    labelFrame.origin.x = self.frame.size.width/2 - self.titleLabel.frame.size.width/2;
    labelFrame.origin.y = (imageFrame.origin.y + self.imageView.frame.size.height + 1);
    
    
    self.imageView.frame = imageFrame;
    self.titleLabel.frame = labelFrame;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self centerVertically];
   
}



- (void)layoutSubviews
{
    // Allow default layout, then adjust image and label positions
    [super layoutSubviews];

    
    
    CGRect imageFrame = self.imageView.frame;
    CGRect labelFrame = self.titleLabel.frame;
    
    
    imageFrame.origin.x = self.frame.size.width/2 - self.imageView.frame.size.width/2;
    imageFrame.origin.y = self.frame.size.height/2 - self.imageView.frame.size.height/2 - 5 ;
    imageFrame.size = CGSizeMake(25.00, 25.00);
    
    
    
    labelFrame.size.width = self.frame.size.width;
    labelFrame.origin.x = self.frame.size.width/2 - self.titleLabel.frame.size.width/2;
    labelFrame.origin.y = (imageFrame.origin.y + self.imageView.frame.size.height + 1);
    
    
    self.imageView.frame = imageFrame;
    self.titleLabel.frame = labelFrame;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
  

   
}



- (void)centerVerticallyWithPadding:(float)padding
{
    //self.imageView.frame.size = CGSizeMake(32.00, 32.00);
    
   
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    CGFloat totalHeight = (imageSize.height + titleSize.height + padding);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height),
                                            0.0f,
                                            0.0f,
                                            - titleSize.width);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                            - imageSize.width,
                                            - (totalHeight - titleSize.height),
                                            0.0f);
    
}


- (void)centerVertically
{
    const CGFloat kDefaultPadding = 0.0f;
    
    [self centerVerticallyWithPadding:kDefaultPadding];
}


@end
