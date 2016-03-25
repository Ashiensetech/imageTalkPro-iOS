//
//  ReceiverSingleTableViewCell.h
//  ImageTalk
//
//  Created by Workspace Infotech on 12/15/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiverSingleTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *text;
@property (strong, nonatomic) IBOutlet UILabel *time;

@end
