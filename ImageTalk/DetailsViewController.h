//
//  DetailsViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/27/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WallPost.h"
#import "LikeResponse.h"
#import "FavResponse.h"
#import "Response.h"
#import "AppDelegate.h"
#import "ApiAccess.h"

@interface DetailsViewController : UIViewController <ApiAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}

@property (strong, nonatomic) AppDelegate *app;
@property (strong, nonatomic) UIAlertView *alertDownload;
@property (strong, nonatomic) UIAlertView *alertDelete;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (strong,nonatomic) LikeResponse *dataLike;
@property (strong,nonatomic) FavResponse *dataFav;
@property (strong,nonatomic) Response *dataDelete;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailsHeight;
@property (strong, nonatomic) IBOutlet UIImageView *downloadImg;
@property (strong, nonatomic) IBOutlet UIImageView *favImg;
@property (strong, nonatomic) IBOutlet UIButton *favBtn;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *likeImg;
@property (strong, nonatomic) IBOutlet UIButton *likeBtn;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *description;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeShowBtn;
@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;
@property (strong, nonatomic) IBOutlet UIButton *detailsBtn;
@property (strong, nonatomic) IBOutlet UIButton *likesBtn;
@property (strong, nonatomic) IBOutlet UIButton *profileBtn;
@property (strong, nonatomic) IBOutlet UIImageView *tagImg;
@property (strong, nonatomic) IBOutlet UIButton *tagBtn;
@property (strong, nonatomic) IBOutlet UIButton *loc;

@property (strong, nonatomic) WallPost *data;

@end
