//
//  ToastView.h
// 
//
//  Created by Workspace Infotech on 5/5/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView

@property (strong, nonatomic) NSString *text;

+ (void)showToastInParentView: (UIView *)parentView withText:(NSString *)text withDuaration:(float)duration;

+ (void)showErrorToastInParentView: (UIView *)parentView withText:(NSString *)text withDuaration:(float)duration;


@end
