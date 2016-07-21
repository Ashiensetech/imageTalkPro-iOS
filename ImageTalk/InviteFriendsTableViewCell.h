//
//  InviteFriendsTableViewCell.h
//  ImageTalk
//
//  Created by Workspace Infotech on 7/20/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contactName;
@property (strong, nonatomic) IBOutlet UIImageView *checked;
@property (assign,nonatomic) BOOL isChecked;

@end
