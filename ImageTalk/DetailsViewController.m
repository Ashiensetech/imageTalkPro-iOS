//
//  DetailsViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/27/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "DetailsViewController.h"
#import "JSONHTTPClient.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ToastView.h"
#import "ApiAccess.h"
#import "UIImageView+WebCache.m"
#import "UIImage+GIF.h"
#import "CommentsViewController.h"
#import "LikesViewController.h"
#import "ShareLocationViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

@synthesize description;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"de");
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden= YES;
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    self.app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.profilePic.layer.cornerRadius = 20.0;
    [self.profilePic.layer setMasksToBounds:YES];
    
    if(_data.type == 2)
    {
        self.imageHeight.constant = 145.00;
    }
    else if(_data.type == 1)
    {
        self.imageHeight.constant = self.view.frame.size.width/2;
    }
    else
    {
        self.imageHeight.constant = self.view.frame.size.width;
    }

    
    if(_data.type == 2)
    {
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        self.favBtn.hidden = true;
        self.downloadBtn.hidden = true;
        self.favImg.hidden = true;
        self.downloadImg.hidden = true;
        
        
    }
    else if(_data.type ==1)
    {
        self.image.contentMode = UIViewContentModeScaleToFill;
        self.favBtn.hidden = true;
        self.downloadBtn.hidden = true;
        self.favImg.hidden = true;
        self.downloadImg.hidden = true;
    }
    else
    {
        self.image.contentMode = UIViewContentModeScaleToFill;
        self.favBtn.hidden = false;
        self.downloadBtn.hidden = false;
        self.favImg.hidden = false;
        self.downloadImg.hidden = false;
    }
    
    self.description.text = (_data.description)?[NSString stringWithFormat:@"%@",_data.description]:@"";
    
    CGSize contentsize = [_data.description sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    if([_data.description isEqual:@""])
    {
        self.detailsHeight.constant = 0;
        
    }
    else
    {
        self.detailsHeight.constant = (contentsize.height < 40 ) ? 40 : contentsize.height;
    }
    
    
    
    self.name.text = [NSString stringWithFormat:@"%@ %@",_data.owner.user.firstName,_data.owner.user.lastName];
    
    NSTimeInterval timestamp = [_data.createdDate longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    date = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    
    if (_data.isLiked)
    {
        self.likeImg.image = [UIImage imageNamed:@"like-aa"];
    }
    else
    {
        self.likeImg.image = [UIImage imageNamed:@"like"];
    }
    
    if (_data.isFavorite)
    {
        self.favImg.image = [UIImage imageNamed:@"star-a"];
    }
    else
    {
        self.favImg.image = [UIImage imageNamed:@"star-1"];
    }
    
    
    
    self.likeLabel.text = [NSString stringWithFormat:@"%d likes",_data.likeCount];
    self.date.text = [NSString stringWithFormat:@"%@ ago",[self AgoStringFromTime:date]];
    [self.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,_data.owner.user.picPath.original.path]]
                       placeholderImage:nil];
    
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,_data.picPath]]
                  placeholderImage:[UIImage sd_animatedGIFNamed:@"image_loader.gif"]];
    
    
    if (_data.places) {
        
        [self.loc setTitle:_data.places.name forState:UIControlStateNormal];
    }
    
    self.commentLabel.text = [NSString stringWithFormat:@"%d comments",_data.comments.count];
    [self.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.downloadBtn addTarget:self action:@selector(downloadClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.favBtn addTarget:self action:@selector(favClick:) forControlEvents:UIControlEventTouchUpInside];
    

}

-(NSString*) AgoStringFromTime : (NSDate*) dateTime
{
    NSDictionary *timeScale = @{@"sec"  :@1,
                                @"min"  :@60,
                                @"hr"   :@3600,
                                @"day"  :@86400,
                                @"week" :@605800,
                                @"month":@2629743,
                                @"year" :@31556926};
    NSString *scale;
    int timeAgo = 0-(int)[dateTime timeIntervalSinceNow];
    if (timeAgo < 60) {
        scale = @"sec";
    } else if (timeAgo < 3600) {
        scale = @"min";
    } else if (timeAgo < 86400) {
        scale = @"hr";
    } else if (timeAgo < 605800) {
        scale = @"day";
    } else if (timeAgo < 2629743) {
        scale = @"week";
    } else if (timeAgo < 31556926) {
        scale = @"month";
    } else {
        scale = @"year";
    }
    
    timeAgo = timeAgo/[[timeScale objectForKey:scale] integerValue];
    NSString *s = @"";
    if (timeAgo > 1) {
        s = @"s";
    }
    
    
    return [NSString stringWithFormat:@"%d %@%@", timeAgo,([scale isEqualToString:@"hr"])?@"hour" : scale , s];
}




-(void)downloadClick:(UIButton*)sender
{
    
    self.alertDownload = [[UIAlertView alloc] initWithTitle:@"Download Picture"
                                                    message:@"Download the picture in your iPhone."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Download", nil];
    self.alertDownload.tag = sender.tag;
    [self.alertDownload show];
    
}

-(void)deleteClick:(UIButton*)sender
{
    
    if (_data.owner.id == self.app.authCredential.id) {
        self.alertDelete = [[UIAlertView alloc] initWithTitle:@"Delete Picture"
                                                      message:@"Delete the Picture from your timeline"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Delete", nil];
        self.alertDelete.tag = sender.tag;
        [self.alertDelete show];
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    
    if (alertView == self.alertDownload) {
        
        if (buttonIndex == 1)
        {
            
            NSURL *imgUrl = [NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,_data.picPath]];
            UIImage *viewImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:imgUrl]];
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageToSavedPhotosAlbum:[viewImage CGImage] orientation:(ALAssetOrientation)[viewImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
                if (error) {
                    NSLog(@"error");
                    [ToastView showToastInParentView:self.view withText:@"Picture not Saved" withDuaration:2.0];
                } else {
                    NSLog(@"url %@", assetURL);
                    [ToastView showToastInParentView:self.view withText:@"Picture Saved" withDuaration:2.0];
                }
            }];
            
        }
    }
    
    if (alertView == self.alertDelete) {
        if (buttonIndex == 1) {
            
            NSDictionary *inventory = @{ @"wall_post_id" : [NSString stringWithFormat:@"%d",_data.id] };
            [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/delete" params:inventory tag:@"deleteData" index:alertView.tag];
        }
    }
    
}


- (IBAction)pop:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)likeClick:(UIButton*)sender
{
    
    NSDictionary *inventory = @{@"post_id" : [NSString stringWithFormat:@"%d",_data.id]};
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/like" params:inventory tag:@"likeData" index:sender.tag];
    
}

-(void)favClick:(UIButton*)sender
{
    
    NSDictionary *inventory = @{@"wall_post_id" : [NSString stringWithFormat:@"%d",_data.id]};
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/add/remove/favourite" params:inventory tag:@"favData" index:sender.tag];
    
}

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    
    
    if ([tag isEqualToString:@"deleteData"])
    {
        
        
        NSError* error = nil;
        self.dataDelete = [[Response alloc] initWithDictionary:data error:&error];
        
        if(self.dataDelete.responseStat.status){
  
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    if ([tag isEqualToString:@"likeData"])
    {
        
        NSError* error = nil;
        self.dataLike = [[LikeResponse alloc] initWithDictionary:data error:&error];
        
        if(self.dataLike.responseStat.status)
        {
            self.likeImg.image = (self.dataLike.responseData.isLiked) ? [UIImage imageNamed:@"like-aa"]:[UIImage imageNamed:@"like"];
            self.likeLabel.text = [NSString stringWithFormat:@"%d likes",self.dataLike.responseData.likeCount];
            _data.isLiked = self.dataLike.responseData.isLiked;
            _data.likeCount = self.dataLike.responseData.likeCount;
            
        }
    }
    
    if ([tag isEqualToString:@"favData"])
    {
        NSError* error = nil;
        self.dataFav = [[FavResponse alloc] initWithDictionary:data error:&error];
        
        
        
        if(self.dataFav.responseStat.status)
        {
            self.favImg.image = (self.dataFav.responseData.isFavorite) ? [UIImage imageNamed:@"star-a"]:[UIImage imageNamed:@"star-1"];
            _data.isFavorite = self.dataFav.responseData.isFavorite;
            
        }
        
    }
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showComment"])
    {
        CommentsViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.postId = _data.id;
        data.postOwnerId = _data.owner.id;
    }
    
    if ([segue.identifier isEqualToString:@"showLocation"])
    {
        ShareLocationViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.title = _data.places.name;
        data.place = _data.places;
    }
    
    
    if ([segue.identifier isEqualToString:@"showLikes"])
    {
        LikesViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.postId = _data.id;
        
    }

}


@end
