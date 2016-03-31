//
//  TimelineViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "TimelineViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "UIImageView+RJLoader.h"
#import "AllPhotosViewController.h"
#import "CommentsViewController.h"
#import "LikesViewController.h"
#import "ToastView.h"
#import "FriendsProfileViewController.h"
#import "ShareLocationViewController.h"
#import "SocketResponse.h"
#import "UIImageView+XLNetworking.h"
#import "UIImageView+XLProgressIndicator.h"
#import "UIImageView+AFNetworking.h"
#import "AcknowledgementResponse.h"
#import "ToastView.h"
#import "NSDate+NVTimeAgo.h"

@interface TimelineViewController ()

@property (strong,nonatomic)UIImage *img;
@property int counter;

@end

@implementation TimelineViewController

@synthesize chatSocket = _chatSocket;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.counter = 0;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden= NO;
    
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 200, 44);
    UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = NO;
    
    
    CGRect titleFrame = CGRectMake(0, 2, 200, 30);
    UILabel *titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"EightOne" size:26.0f];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    titleView.text =[NSString stringWithFormat:@"ImageTalk"];
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    
    self.navigationItem.titleView = _headerTitleSubtitleView;

    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    socketurl = [defaults objectForKey:@"socketurl"];
    port = [defaults objectForKey:@"port"];
    
    self.app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableData addSubview:self.refreshControl];
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    self.myObject = [[NSMutableArray alloc] init];
    self.offset = 0;
    self.loaded = false;
    [self getData:self.offset];

    
    [[SocektAccess getSharedInstance]setItem:[self.tabBarController.tabBar.items objectAtIndex:1]];
}


- (IBAction)refresh:(id)sender {
    
    self.myObject = [[NSMutableArray alloc] init];    
    self.offset = 0;
    self.loaded = false;
    [self getData:self.offset];
}




-(void)viewDidAppear:(BOOL)animated
{
    [[ApiAccess getSharedInstance] setDelegate:self];
    [[[SocektAccess getSharedInstance]getSocket]setDelegate:self];
    [[[SocektAccess getSharedInstance]getSocket] reconnect];
    _chatSocket =[[SocektAccess getSharedInstance]getSocket];

    
    if(self.updateWill)
    {
        
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.updateId inSection:0];
            
            NSLog(@"Update Value: %d",self.updateValue);
            NSLog(@"Update ID: %d",self.updateId);
            
            
            
            TimelineTableViewCell *cell = (TimelineTableViewCell *)[self.tableData cellForRowAtIndexPath:indexPath];
            cell.commentLabel.text = [NSString stringWithFormat:@"%d comments",self.updateValue];
            
            WallPost *data = self.myObject[indexPath.row];
            data.commentCount = self.updateValue;
        
           [self.myObject replaceObjectAtIndex:indexPath.row withObject:data];

              WallPost *data2 = self.myObject[indexPath.row];
        
             NSLog(@": %d",data2.commentCount);
        
            [self.tableData reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableData reloadData];
       
        
    }
    
    self.updateWill = NO;
}



- (void)refresh{
    self.offset = 0;
    self.loaded = false;
    self.myObject = nil;
    self.myObject = [[NSMutableArray alloc] init];
    [self getData:self.offset];
    [self.refreshControl endRefreshing];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getData:(int) offset{
    
    NSDictionary *inventory = @{@"offset" : [NSString stringWithFormat:@"%d",offset] };
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/get/recent" params:inventory tag:@"getTimelineData"];
    
}


#pragma mark - table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myObject.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    
    WallPost *data = self.myObject[indexPath.row];
    
    CGFloat height;
    
    if(data.type == 2)
    {
        height = 260.00;
    }
    else if(data.type == 1)
    {
        height = self.view.frame.size.width/2 + 115;
    }
    else
    {
        NSString *filePath = [NSString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.picPath];
        self.img = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]]];
      
        
        if (self.img.size.width > CGRectGetWidth(self.view.bounds)) {
            CGFloat ratio = self.img.size.height / self.img.size.width;
            return CGRectGetWidth(self.view.bounds) * ratio+120;
        } else {
            return self.img.size.height+110;
        }
       
        //height = self.view.frame.size.width + 100;
        
        
    }
    
    
    
    
    if(![data.description isEqual:@""])
    {
        CGSize size = [data.description sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        height = height + ((size.height < 40)? 40 : size.height);
    }


    return height;

}

-(void) tableView:(UITableView *)tableView willDisplayCell:(TimelineTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    self.counter = 0;
    
    WallPost *data = self.myObject[indexPath.row];
   
    cell.image.userInteractionEnabled = YES;
    cell.image.tag = indexPath.row;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabOnImage:)];
    tapped.numberOfTapsRequired = 1;
    [cell.image addGestureRecognizer:tapped];
    
    NSLog(@"tag count :%d,%@",data.tagCount,data.description);
    
    
   if(data.tagCount<1)
   {
      cell.tagIcon.hidden = true;
      cell.tagBtn.hidden = true;
   }
   else
   {
       cell.tagIcon.hidden = false;
       cell.tagBtn.hidden = false;
   }

    
    
    if(data.type == 2)
    {
        cell.image.contentMode = UIViewContentModeScaleAspectFit;
        cell.favBtn.hidden = true;
        cell.downloadBtn.hidden = true;
        cell.favImg.hidden = true;
        cell.downloadImg.hidden = true;
        
        
    }
    else if(data.type ==1)
    {
        cell.image.contentMode = UIViewContentModeScaleToFill;
        cell.favBtn.hidden = true;
        cell.downloadBtn.hidden = true;
        cell.favImg.hidden = true;
        cell.downloadImg.hidden = true;
    }
    else
    {
        if(cell.image.image.size.height<cell.image.frame.size.height)
        {
            cell.image.frame = CGRectMake(cell.image.frame.origin.x, cell.image.frame.origin.y,cell.image.frame.size.width, cell.image.frame.size.height);
        }
        cell.image.contentMode = UIViewContentModeScaleToFill;
        cell.favBtn.hidden = false;
        cell.downloadBtn.hidden = false;
        cell.favImg.hidden = false;
        cell.downloadImg.hidden = false;
    }
    
    cell.description.text = (data.description)?[NSString stringWithFormat:@"%@",data.description]:@"";
    
    CGSize contentsize = [data.description sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    if([data.description isEqual:@""])
    {
        cell.detailsHeight.constant = 0;
        
    }
    else
    {
        cell.detailsHeight.constant = (contentsize.height < 40 ) ? 40 : contentsize.height;
    }

    
    
    cell.name.text = [NSString stringWithFormat:@"%@ %@",data.owner.user.firstName,data.owner.user.lastName];
    
    NSTimeInterval timestamp = [data.createdDate longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    date = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"MMMM dd, hh:mm a"];
    //[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    //NSString *dateStr = [dateFormatter stringFromDate:date];
    //date = [dateFormatter dateFromString:dateStr];
    
    if (data.isLiked)
    {
        cell.likeImg.image = [UIImage imageNamed:@"like-aa"];
    }
    else
    {
        cell.likeImg.image = [UIImage imageNamed:@"like"];
    }
    
    if (data.isFavorite)
    {
        cell.favImg.image = [UIImage imageNamed:@"star-a"];
    }
    else
    {
        cell.favImg.image = [UIImage imageNamed:@"star-1"];
    }
    
    
    
    cell.likeLabel.text = [NSString stringWithFormat:@"%d likes",data.likeCount];
    
    cell.date.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:date]];
    
   // cell.date.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    
    
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.owner.user.picPath.original.path]]
                       placeholderImage:nil];

    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.picPath]]
                 placeholderImage:[UIImage sd_animatedGIFNamed:@"image_loader.gif"]];
   
    
   // [cell.image setImageWithProgressIndicatorAndURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.picPath]]];
    
    
    if (data.places) {
        
        [cell.loc setTitle:data.places.name forState:UIControlStateNormal];
    }
   
    cell.likesBtn.tag = indexPath.row;
    
    cell.commentBtn.tag = indexPath.row;
    
    cell.commentLabel.text = [NSString stringWithFormat:@"%lu comments",(unsigned long)data.comments.count];
    
    cell.profileBtn.tag = indexPath.row;
    cell.loc.tag = indexPath.row;
    
    cell.likeBtn.tag = indexPath.row;
    [cell.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.downloadBtn.tag = indexPath.row;
    [cell.downloadBtn addTarget:self action:@selector(downloadClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.detailsBtn.tag = indexPath.row;
    [cell.detailsBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.favBtn.tag = indexPath.row;
    [cell.favBtn addTarget:self action:@selector(favClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
}

-(void)tabOnImage :(id) sender
{
    //TimelineTableViewCell *cell =
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:gesture.view.tag inSection:0];
    WallPost *data = self.myObject[indexPath.row];
    NSLog(@"Tag = %d", data.tagCount);
    NSLog(@"%ld",(long)indexPath.row);
    TimelineTableViewCell *cell = [self.tableData cellForRowAtIndexPath:indexPath];
    UIView *view = cell.imageView;
    
    int value = 150;
    int value2 = 25;
    if(self.counter==0)
    {
        
        NSLog(@"%d",self.counter);
    for(int i = 0;i<data.tagCount;i++)
    {
        
       // NSLog(@"%@",[[data.tagList objectAtIndex:i ]U]);
        AppCredential *appcredential =  [data.tagList objectAtIndex:i] ;
        NSLog(@"%@",appcredential.user.firstName);
        
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(value2,value,120,20)]; //or whatever size you need
        value+=25;
        value2+=50;
       // myLabel.backgroundColor = [UIColor blackColor];
       [myLabel setFont:[UIFont systemFontOfSize:12]];
        
        myLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        myLabel.textColor = [UIColor whiteColor];
        myLabel.textAlignment = NSTextAlignmentCenter;
        myLabel.text = [NSString stringWithFormat:@"%@  %@",appcredential.user.firstName,appcredential.user.lastName] ;

        [view addSubview:myLabel];
       
    }
    
         self.counter = 1;
        
        
    }
    else{
        
        NSLog(@"%d",self.counter);
        self.counter = 0;
 
        for (id child in [view subviews])
        {
            if ([child isMemberOfClass:[UILabel class]])
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
    
    
    return [dateTime formattedAsTimeAgo];//[NSString stringWithFormat:@"%d %@%@", timeAgo,([scale isEqualToString:@"hr"])?@"hour" : scale , s];
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    WallPost *data = self.myObject[indexPath.row];
    
    if (data.owner.id == self.app.authCredential.id) {
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
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
            WallPost *data = self.myObject[indexPath.row];
            
            NSURL *imgUrl = [NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.picPath]];
            UIImage *viewImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:imgUrl]];
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            // Request to save the image to camera roll
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
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
            WallPost *data = self.myObject[indexPath.row];
            
            NSDictionary *inventory = @{ @"wall_post_id" : [NSString stringWithFormat:@"%d",data.id] };
            
            [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/delete" params:inventory tag:@"deleteData" index:alertView.tag];

            
        }
    }
   
}


-(void)likeClick:(UIButton*)sender
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    WallPost *data = self.myObject[indexPath.row];
    
    NSDictionary *inventory = @{@"post_id" : [NSString stringWithFormat:@"%d",data.id]};
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/like" params:inventory tag:@"likeData" index:sender.tag];
    
    
}

-(void)favClick:(UIButton*)sender
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    WallPost *data = self.myObject[indexPath.row];
    
    NSDictionary *inventory = @{@"wall_post_id" : [NSString stringWithFormat:@"%d",data.id]};
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/add/remove/favourite" params:inventory tag:@"favData" index:sender.tag];
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    self.counter = 0;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if(y > h + reload_distance) {
        
        
        if(self.isData && self.loaded)
        {
            
            self.loaded = false;
            [self getData:self.offset];
            
            NSLog(@"load more rows");
        }
        
        
    }
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   //  WallPost *data = self.myObject[indexPath.row];
    NSLog(@"ns lo c");
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender {
    
    if ([segue.identifier isEqualToString:@"sharePhoto"])
    {
        AllPhotosViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.isTimeline = YES;
    }
    
    if ([segue.identifier isEqualToString:@"showComment"])
    {
        CommentsViewController *data = [segue destinationViewController];
        WallPost *post = self.myObject[sender.tag];
        data.hidesBottomBarWhenPushed = YES;
        data.index  = sender.tag;
        data.postId = post.id;
        data.postOwnerId = post.owner.id;
    }
    
    if ([segue.identifier isEqualToString:@"showLocation"])
    {
        ShareLocationViewController *data = [segue destinationViewController];
        WallPost *post = self.myObject[sender.tag];
        data.hidesBottomBarWhenPushed = YES;
        data.title = post.places.name;
        data.place = post.places;
    }

    
    if ([segue.identifier isEqualToString:@"showLikes"])
    {
        LikesViewController *data = [segue destinationViewController];
        WallPost *post = self.myObject[sender.tag];
        data.hidesBottomBarWhenPushed = YES;
        data.postId = post.id;

    }
    
    if ([segue.identifier isEqualToString:@"friendsProfile"])
    {
        FriendsProfileViewController *data = [segue destinationViewController];
        WallPost *post = self.myObject[sender.tag];
        data.hidesBottomBarWhenPushed = YES;
        data.owner = post.owner;
        
    }
    
    
    
    

}

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    
    if ([tag isEqualToString:@"getTimelineData"])
    {
        
        NSError* error = nil;
        self.data = [[TimelineResponse alloc] initWithDictionary:data error:&error];
        
        
        if(self.data.responseStat.status)
        {
            for(int i=0;i<self.data.responseData.count;i++)
            {
                [self.myObject addObject:self.data.responseData[i]];
                
            }
           
        }
     
        self.isData = self.data.responseStat.status;
        self.loaded = self.data.responseStat.status;
        self.offset = (self.data.responseStat.status) ? self.offset+1 : self.offset;
        self.tableData.hidden = (self.myObject.count>0) ? false : true;
        self.emptyView.hidden = (self.myObject.count>0) ? true : false;
       
        [self.tableData reloadData];

    }
    
    if ([tag isEqualToString:@"deleteData"])
    {
       
        
        NSError* error = nil;
        self.dataDelete = [[Response alloc] initWithDictionary:data error:&error];
 
        if(self.dataDelete.responseStat.status){
            
            [self.myObject removeObjectAtIndex:index];
            
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.tableData deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableData reloadData];
            
            
        }
        
    }
    
    if ([tag isEqualToString:@"likeData"])
    {
    
       NSError* error = nil;
       self.dataLike = [[LikeResponse alloc] initWithDictionary:data error:&error];

       if(self.dataLike.responseStat.status)
       {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        TimelineTableViewCell *cell = (TimelineTableViewCell *)[self.tableData cellForRowAtIndexPath:indexPath];
        cell.likeImg.image = (self.dataLike.responseData.isLiked) ? [UIImage imageNamed:@"like-aa"]:[UIImage imageNamed:@"like"];
        cell.likeLabel.text = [NSString stringWithFormat:@"%d likes",self.dataLike.responseData.likeCount];
        
        WallPost *data = self.myObject[indexPath.row];
        data.isLiked = self.dataLike.responseData.isLiked;
        data.likeCount = self.dataLike.responseData.likeCount;
        
        
        [self.tableData reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableData reloadData];
        
        }
    }
    
    if ([tag isEqualToString:@"favData"])
    {
        NSError* error = nil;
        self.dataFav = [[FavResponse alloc] initWithDictionary:data error:&error];
       
       
        
        if(self.dataFav.responseStat.status)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            TimelineTableViewCell *cell = (TimelineTableViewCell *)[self.tableData cellForRowAtIndexPath:indexPath];
            cell.favImg.image = (self.dataFav.responseData.isFavorite) ? [UIImage imageNamed:@"star-a"]:[UIImage imageNamed:@"star-1"];
            
            WallPost *data = self.myObject[index];
            data.isFavorite = self.dataFav.responseData.isFavorite;
            
            
            [self.tableData reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableData reloadData];
            
        }

    }
    
    
   
    


}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
    if ([tag isEqualToString:@"getTimelineData"])
    {
       self.tableData.hidden = true;
       self.emptyView.hidden = false;
       [self.tableData reloadData];
    }
    
   
}


#pragma mark - tcpSocketDelegate
-(void)receivedMessage:(NSString *)data
{
    
    NSError* err = nil;
    SocketResponse *response = [[SocketResponse alloc] initWithString:data error:&err];
    NSLog(@"ASD %@",response);
    
    
    if([response.responseStat.tag isEqualToString:@"textchat"] || [response.responseStat.tag isEqualToString:@"chatphoto_transfer"] || [response.responseStat.tag isEqualToString:@"chatprivatephoto_transfer"] || [response.responseStat.tag isEqualToString:@"chatlocation_share"] || [response.responseStat.tag isEqualToString:@"chatcontact_share"] || [response.responseStat.tag isEqualToString:@"chat_private_photo_took_snapshot"])
    {
        [SocektAccess getSharedInstance].badgeValue++;
        [[SocektAccess getSharedInstance]setBadge];
    }
    
    
}


@end
