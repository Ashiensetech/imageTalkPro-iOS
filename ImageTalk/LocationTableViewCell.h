//
//  LocationTableViewCell.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/16/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//.

#import <UIKit/UIKit.h>

@interface LocationTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end
