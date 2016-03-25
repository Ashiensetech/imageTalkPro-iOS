//
//  FriendsProfileViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/28/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppCredential.h"
#import "TimelineResponse.h"
#import "JSONHTTPClient.h"
#import "TimelineTableViewCell.h"
#import "LikeResponse.h"
#import "FavResponse.h"
#import "ApiAccess.h"

@interface FriendsProfileViewController : UIViewController<ApiAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionData;
@property (strong, nonatomic)  NSMutableArray *myObject;
@property (strong, nonatomic) IBOutlet UITableView *tableData;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) AppCredential  *owner;
@property (strong, nonatomic) IBOutlet UILabel *wallpost;
@property (strong, nonatomic) IBOutlet UILabel *percent;
@property (strong, nonatomic) IBOutlet UITextField *textStatus;
@property (strong,nonatomic) TimelineResponse *data;
@property (strong,nonatomic) LikeResponse *dataLike;
@property (strong,nonatomic) FavResponse *dataFav;
@property (strong,nonatomic) WallPost *post;
@property (assign,nonatomic) int offset;
@property (assign,nonatomic) BOOL isData;
@property (assign,nonatomic) BOOL loaded;
@property (strong,nonatomic) UIRefreshControl *refreshControl;

@end
