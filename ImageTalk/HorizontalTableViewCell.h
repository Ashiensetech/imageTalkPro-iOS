//
//  HorizontalTableViewCell.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/9/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIImageView *coverPic;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *subTitle;
@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;
@property (strong, nonatomic) IBOutlet UIButton *allBtn;



@end
