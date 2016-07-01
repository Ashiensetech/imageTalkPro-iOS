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

@property (assign,nonatomic) int counter;
@end

@implementation DetailsViewController

@synthesize description;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Details");
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
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

    if(_data.tagCount==0)
    {
        [self.tagImg setHidden:YES];
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
    
    
    
    NSString *descriptionTxt = @"";
    
    if(_data.description){
        NSData *strData = [_data.description dataUsingEncoding:NSUTF8StringEncoding];
        descriptionTxt = [[NSString alloc] initWithData:strData encoding:NSNonLossyASCIIStringEncoding];
    }else{
        descriptionTxt = @"";
    }
    
    
    self.description.text = descriptionTxt;
    
    
    
    
    self.description.lineBreakMode = NSLineBreakByWordWrapping;
    self.description.numberOfLines = 0;
    self.description.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    
    
   
    
    CGSize contentsize = [descriptionTxt sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    if([_data.description isEqual:@""])
    {
        self.detailsHeight.constant = 0;
        
    }
    else
    {
        self.detailsHeight.constant = (contentsize.height < 40 ) ? 40 : contentsize.height;
    }
    
    
    
    self.name.text = [NSString stringWithFormat:@"%@ %@",_data.owner.user.firstName,_data.owner.user.lastName];
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd HH:mm:ss.0";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
    
    NSString *dateStr = _data.createdDate;
    NSDate *old =  [dateFormatter dateFromString:dateStr];
    
    NSLog(@"The old time in current date format: %@",old);
    
    NSTimeZone* sourceTimeZone = [NSTimeZone systemTimeZone];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:old];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:now];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    
    
    
    
    old = [[NSDate alloc] initWithTimeInterval:interval sinceDate:old];
    
 
    
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
    self.date.text = [NSString stringWithFormat:@"%@ ago",[self AgoStringFromTime:old]];
    
    if([_data.wallPostMood isEqual:@"" ] || [_data.wallPostMood isEqual:@"None"])
    {
        
        [self.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,_data.owner.user.picPath.original.path]]
                           placeholderImage:nil];
    }
    else if([_data.wallPostMood isEqual:@"Angry"])
    {
        self.profilePic.image = [UIImage imageNamed:@"angryL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Beauty"])
    {
        self.profilePic.image = [UIImage imageNamed:@"beautyL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Boozing"])
    {
        self.profilePic.image = [UIImage imageNamed:@"boozingL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Chilling"])
    {
        self.profilePic.image = [UIImage imageNamed:@"chillingL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Coding"])
    {
        self.profilePic.image = [UIImage imageNamed:@"codingL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Coffee"])
    {
      self.profilePic.image = [UIImage imageNamed:@"coffeeL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Confused"])
    {
        self.profilePic.image = [UIImage imageNamed:@"confusedL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Cooking"])
    {
        self.profilePic.image = [UIImage imageNamed:@"cookingL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Driving"])
    {
        self.profilePic.image = [UIImage imageNamed:@"drivingL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Eating"])
    {
        self.profilePic.image = [UIImage imageNamed:@"eatingL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Gaming"])
    {
        self.profilePic.image = [UIImage imageNamed:@"GamingL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Hangover"])
    {
        self.profilePic.image = [UIImage imageNamed:@"hangoverL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Happy"])
    {
        self.profilePic.image = [UIImage imageNamed:@"happyL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"In Love"])
    {
        self.profilePic.image = [UIImage imageNamed:@"inloveL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Insomnia"])
    {
        self.profilePic.image = [UIImage imageNamed:@"insomiaL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Late"])
    {
        self.profilePic.image = [UIImage imageNamed:@"lateL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Love"])
    {
        self.profilePic.image = [UIImage imageNamed:@"loveL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Making"])
    {
        self.profilePic.image = [UIImage imageNamed:@"makingL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Middle"])
    {
        self.profilePic.image = [UIImage imageNamed:@"middleL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Movie"])
    {
        self.profilePic.image = [UIImage imageNamed:@"movieL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Music"])
    {
        self.profilePic.image = [UIImage imageNamed:@"musicL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Read"])
    {
        self.profilePic.image = [UIImage imageNamed:@"readL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Sad"])
    {
        self.profilePic.image = [UIImage imageNamed:@"sadL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Shopping"])
    {
        self.profilePic.image = [UIImage imageNamed:@"ShoppingL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Singing"])
    {
        self.profilePic.image = [UIImage imageNamed:@"singingL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Sleepy"])
    {
        self.profilePic.image = [UIImage imageNamed:@"sleepyL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Smoking"])
    {
        self.profilePic.image = [UIImage imageNamed:@"smokingL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Surprised"])
    {
        self.profilePic.image = [UIImage imageNamed:@"surprisedL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Stuck In Traffic"])
    {
        self.profilePic.image = [UIImage imageNamed:@"trafficL.png"];
        
    }
    else if([_data.wallPostMood isEqual:@"Workout"])
    {
        self.profilePic.image = [UIImage imageNamed:@"workoutL.png"];
        
    }
  
    
    [self.image setUserInteractionEnabled:YES];
    [self.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,_data.picPath]]
                  placeholderImage:[UIImage sd_animatedGIFNamed:@"image_loader.gif"]];
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabOnImage:)];
    tapped.numberOfTapsRequired = 1;
    [self.image addGestureRecognizer:tapped];
    
    UITapGestureRecognizer *doubleTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTabOnImage:)];
    doubleTapped.numberOfTapsRequired = 2;
    [self.image addGestureRecognizer:doubleTapped];
    
    if (_data.places) {
        
        [self.loc setTitle:_data.places.name forState:UIControlStateNormal];
    }
    
    self.commentLabel.text = [NSString stringWithFormat:@"%d comments",_data.commentCount];
    [self.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.downloadBtn addTarget:self action:@selector(downloadClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.favBtn addTarget:self action:@selector(favClick:) forControlEvents:UIControlEventTouchUpInside];
    

}
-(void)doubleTabOnImage :(id) sender
{
    NSLog(@"INSIDE");
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:gesture.view.tag inSection:0];
//    WallPost *data = self.myObject[indexPath.row];
//    TimelineTableViewCell *cell = [self.tableData cellForRowAtIndexPath:indexPath];
    
    
    UIImageView *blackView = [[UIImageView alloc] init];
    blackView.frame = CGRectMake( 0, 0, self.image.frame.size.width, self.image.frame.size.height);
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.6f;
    [self.image addSubview:blackView];
    
    
    UIImage *image = [UIImage imageNamed:@"heart.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake((self.view.frame.size.width / 2) - (image.size.width / 2), (self.view.frame.size.height / 2) - (image.size.height), image.size.width, image.size.height-10);
    [self.image addSubview:imageView];
    
    
    
    
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        // Animate the alpha value of your imageView from 1.0 to 0.0 here
        imageView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
        imageView.hidden = YES;
        blackView.hidden = YES;
        if (_data.isLiked == 1)
        {
            
        }
        else
        {
            
            NSDictionary *inventory = @{@"post_id" : [NSString stringWithFormat:@"%d",_data.id]};
            [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/like" params:inventory tag:@"likeData" index:(int)self.image.tag];
            
        }
        
        
    }];
    
    
    
    
    
    
}

-(void)tabOnImage :(id) sender
{
    //TimelineTableViewCell *cell =
//    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:gesture.view.tag inSection:0];
//    WallPost *data = self.myObject[indexPath.row];
//    NSLog(@"Tag = %d", data.tagCount);
//    NSLog(@"%ld",(long)indexPath.row);
//    TimelineTableViewCell *cell = [self.tableData cellForRowAtIndexPath:indexPath];
//    
    NSLog(@"tag List : %@",_data.tagList);
    
    if(self.counter==0)
    {
        
        NSLog(@"%d",self.counter);
        for(int i = 0;i<_data.tagCount;i++)
        {
            Tag *tag =  [_data.tagList objectAtIndex:i] ;
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,120,20)];
            view.center = CGPointMake([tag.originX floatValue], [tag.originY floatValue]);
            // view.userInteractionEnabled = YES;
            
            
            UIImageView *thumbnailImage;
            thumbnailImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 120, 20)];
            thumbnailImage.image = [UIImage imageNamed:@"arrow-2.png"];
            [thumbnailImage setContentMode:UIViewContentModeScaleAspectFill];
            thumbnailImage.clipsToBounds = YES;
            
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,20)]; //or whatever size you need
            // myLabel.center = self.tabPosition;
            [myLabel setFont:[UIFont systemFontOfSize:12]];
            myLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
            myLabel.textColor = [UIColor whiteColor];
            myLabel.textAlignment = NSTextAlignmentCenter;
            myLabel.text = [NSString stringWithFormat:@"%@  %@",tag.tagId.user.firstName,tag.tagId.user.lastName] ;
            
            
            [view addSubview:thumbnailImage];
            [view addSubview:myLabel];
            [self.image addSubview:view];
            
        }
        
        self.counter = 1;
        
        
    }
    else{
        
        NSLog(@"%d",self.counter);
        self.counter = 0;
        
        for (id child in [self.image subviews])
        {
            if ([child isMemberOfClass:[UIView class]])
            {
                [child removeFromSuperview];
            }
        }
        
    }
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
    
    self.alertDelete =   [UIAlertController
                          alertControllerWithTitle:nil
                          message:nil
                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Remove Post"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
//                             
//                             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
//                             WallPost *data = self.myObject[indexPath.row];
//                             
                             NSLog(@"post id: %d",_data.id);
                             NSDictionary *inventory = @{ @"wall_post_id" : [NSString stringWithFormat:@"%d",_data.id] };
                             if (_data.owner.id == self.app.authCredential.id) {
                                 [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/delete" params:inventory tag:@"deleteData" index:(int)sender.tag];
                             }
                             else
                             {
                                 [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/hide" params:inventory tag:@"deleteData" index:(int)sender.tag];
                             }
                             
                             
                             
                             [self.alertDelete dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self.alertDelete dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    
    
    [self.alertDelete addAction:ok];
    [self.alertDelete addAction:cancel];
    self.alertDelete.view.tintColor = [UIColor orangeColor];
    [self presentViewController:self.alertDelete animated:YES completion:nil];
    
//    if (_data.owner.id == self.app.authCredential.id) {
//        self.alertDelete = [[UIAlertView alloc] initWithTitle:@"Delete Picture"
//                                                      message:@"Delete the Picture from your timeline"
//                                                     delegate:self
//                                            cancelButtonTitle:@"Cancel"
//                                            otherButtonTitles:@"Delete", nil];
//        self.alertDelete.tag = sender.tag;
//        [self.alertDelete show];
//    }
    
    
    
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
