//
//  UIUnderlineButton.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "UIUnderlineButton.h"

@implementation UIUnderlineButton

+ (UIUnderlineButton*) underlinedButton {
    UIUnderlineButton* button = [[UIUnderlineButton alloc] init];
    return button;
}

- (void) drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    
    // need to put the line at top of descenders (negative value)
    CGFloat descender = self.titleLabel.font.descender;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender+5);
    
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width+5, textRect.origin.y + textRect.size.height + descender+5);
    
    CGContextClosePath(contextRef);
    
    CGContextDrawPath(contextRef, kCGPathStroke);
}



@end
