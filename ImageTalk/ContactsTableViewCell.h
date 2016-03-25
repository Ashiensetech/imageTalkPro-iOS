//
//  ContactsTableViewCell.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/13/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *jobPic;
@property (strong, nonatomic) IBOutlet UILabel *sub;

@end
