//
//  CommentsTableViewCell.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/16/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *comment;
@property (strong, nonatomic) IBOutlet UIButton *click;


@end
