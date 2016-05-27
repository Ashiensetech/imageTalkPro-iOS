//
//  TimelineViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "TimelineViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
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
@property int counter1;
@property UILabel *topView;

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
    
    UITabBarController *tabBarController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController ;
    
    [tabBarController setDelegate:self];
   
    self.topView = [[UILabel alloc] init];
    self.topView.frame = CGRectMake( 0, 0,self.view.frame.size.width, 20);
    self.topView.backgroundColor = [UIColor orangeColor];
    

    self.view.backgroundColor = [UIColor whiteColor];
    
   // self.topView.hidden = YES;
    
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
   NSLog(@"comeon: %@", tabBarController);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    [self.tableData scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    
    
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
        NSLog(@"viewDidAppear");
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.updateId inSection:0];
        
        NSLog(@"Update Value: %d",self.updateValue);
        NSLog(@"Update ID: %d",self.updateId);
        
    
        
        
        
        
//        [self.tableData reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableData reloadData];
        
        
        [self.tableData reloadData];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                NSArray *paths = [self.tableData indexPathsForVisibleRows];
                for (NSIndexPath *path in paths)
                {
                    //get desired cell here
                    if(path ==indexPath)
                    {
                    TimelineTableViewCell *cell = (TimelineTableViewCell *)[self.tableData cellForRowAtIndexPath:path];
                    
                    WallPost *data = self.myObject[path.row];
                    data.commentCount = (int)self.updateValue;
                    
                    [self.myObject replaceObjectAtIndex:path.row withObject:data];
                    
                    
                    
                    cell.commentLabel.text = [NSString stringWithFormat:@"%d comments",data.commentCount]; //now you can update here on your cell items
                
                    }
                    }
                
            });
        });
        
        
        
        
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
        height = self.view.frame.size.width/2 + 100;
        
        
    }
    else
    {
        
        NSURL *filePath = [NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.picPath]];
        
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:filePath];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
        
        if(image != NULL)
        {
            self.img = image;
        }
        else
        {
            SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
            [downloader downloadImageWithURL:filePath
                                     options:0
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                        // progression tracking code
                                    }
                                   completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                       if (image && finished) {
                                           // do something with image
                                           
                                           self.img = image;
                                           
                                       }
                                   }];
            
        }
        
        
        if (self.img.size.width > CGRectGetWidth(self.view.bounds)) {
            CGFloat ratio = self.img.size.height / self.img.size.width;
            height = CGRectGetWidth(self.view.bounds) * ratio+140;
        } else {
            
            height = self.img.size.height;
        }
        
        
        
        
    }
    
    
    
    
    if(![data.description isEqual:@""])
    {
        CGSize size = [data.description sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:CGSizeMake(280, MAXFLOAT) ];
        
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
    
    

    
    
    
    NSLog(@"comments count: %d",data.commentCount);
    NSLog(@"wall post id: %d",data.id);
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabOnImage:)];
    tapped.numberOfTapsRequired = 1;
    [cell.image addGestureRecognizer:tapped];
    
    UITapGestureRecognizer *doubleTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTabOnImage:)];
    doubleTapped.numberOfTapsRequired = 2;
    [cell.image addGestureRecognizer:doubleTapped];
    
    
    
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
        
        
        
        cell.image.contentMode = UIViewContentModeScaleToFill;
        cell.favBtn.hidden = false;
        cell.downloadBtn.hidden = false;
        cell.favImg.hidden = false;
        cell.downloadImg.hidden = false;
    }
    
    cell.description.text = (data.description)?[NSString stringWithFormat:@"%@",data.description]:@"";
    
  
    
   
    cell.description.lineBreakMode = NSLineBreakByWordWrapping;
    cell.description.numberOfLines = 0;
    cell.description.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    
    
    UIFont *cellFont = cell.textLabel.font;
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [data.description sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
   
    
    if([data.description isEqual:@""])
    {
        
        cell.detailsHeight.constant = 0;
        
    }
    else
    {
        if(labelSize.height<40)
        {
             cell.detailsHeight.constant = 40;
        }
        else{
            
            cell.detailsHeight.constant = labelSize.height-20;
        }
    }
    
    
    
    cell.name.text = [NSString stringWithFormat:@"%@ %@",data.owner.user.firstName,data.owner.user.lastName];
    
    NSLog(@"Timestamp: %@",data.createdDate);
    
    //NSTimeInterval timestamp = [data.createdDate longLongValue];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
//    NSLog(@"old date: %@",date);
   
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd HH:mm:ss.0";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
    
    NSString *dateStr = data.createdDate;
    NSDate *old =  [dateFormatter dateFromString:dateStr];
    
    NSLog(@"The old time in current date format: %@",old);
    
    NSTimeZone* sourceTimeZone = [NSTimeZone systemTimeZone];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:old];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:now];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    
    
    
    
    old = [[NSDate alloc] initWithTimeInterval:interval sinceDate:old];
    
    
    
    
    
    if (data.isLiked == 1)
    {
        NSLog(@"Insideeeee");
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
    
    cell.date.text = [NSString stringWithFormat:@"%@",[self AgoStringFromTime:old]];
    
    // cell.date.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    
    
    
    NSLog(@"wallpostmood: %@",data.wallPostMood);
    if([data.wallPostMood isEqual:@"" ] || [data.wallPostMood isEqual:@"None"])
    {
        
        [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.owner.user.picPath.original.path]]
                           placeholderImage:nil];
    }
    else if([data.wallPostMood isEqual:@"Angry"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"angryL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Beauty"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"beautyL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Boozing"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"boozingL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Chilling"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"chillingL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Coding"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"codingL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Coffee"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"coffeeL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Confused"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"confusedL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Cooking"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"cookingL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Driving"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"drivingL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Eating"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"eatingL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Gaming"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"GamingL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Hangover"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"hangoverL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Happy"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"happyL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"In Love"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"inloveL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Insomnia"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"insomiaL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Late"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"lateL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Love"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"loveL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Making"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"makingL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Middle"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"middleL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Movie"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"movieL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Music"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"musicL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Read"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"readL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Sad"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"sadL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Shopping"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"ShoppingL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Singing"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"singingL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Sleepy"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"sleepyL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Smoking"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"smokingL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Surprised"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"surprisedL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Stuck In Traffic"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"trafficL.png"];
        
    }
    else if([data.wallPostMood isEqual:@"Workout"])
    {
        cell.profilePic.image = [UIImage imageNamed:@"workoutL.png"];
        
    }
    
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.picPath]]
     ];
    
    
    if (data.places) {
        
        [cell.loc setTitle:data.places.name forState:UIControlStateNormal];
    }
    
    cell.likesBtn.tag = indexPath.row;
    
    cell.commentBtn.tag = indexPath.row;
    
    cell.commentLabel.text = [NSString stringWithFormat:@"%d comments",data.commentCount];
    
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


-(void)doubleTabOnImage :(id) sender
{
    NSLog(@"INSIDE");
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:gesture.view.tag inSection:0];
    WallPost *data = self.myObject[indexPath.row];
    TimelineTableViewCell *cell = [self.tableData cellForRowAtIndexPath:indexPath];
    
    
    UIImageView *blackView = [[UIImageView alloc] init];
    blackView.frame = CGRectMake( 0, 0, cell.image.frame.size.width, cell.image.frame.size.height);
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.6f;
    [cell.image addSubview:blackView];
    
    
    UIImage *image = [UIImage imageNamed:@"heart.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake((cell.frame.size.width / 2) - (image.size.width / 2), (cell.frame.size.height / 2) - (image.size.height), image.size.width, image.size.height-10);
    [cell.image addSubview:imageView];
    
    
    
    
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        // Animate the alpha value of your imageView from 1.0 to 0.0 here
        imageView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
        imageView.hidden = YES;
        blackView.hidden = YES;
        if (data.isLiked == 1)
        {
            
        }
        else
        {
            
            NSDictionary *inventory = @{@"post_id" : [NSString stringWithFormat:@"%d",data.id]};
            [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/like" params:inventory tag:@"likeData" index:cell.image.tag];
            
        }
        
        
    }];
    
    
    
    
    
    
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
    
    
   
    if(self.counter==0)
    {
        
        NSLog(@"%d",self.counter);
        for(int i = 0;i<data.tagCount;i++)
        {
            
            // NSLog(@"%@",[[data.tagList objectAtIndex:i ]U]);
            Tag *tag =  [data.tagList objectAtIndex:i] ;
            NSLog(@"%@",tag.tagId.user.firstName);
            
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,20)]; //or whatever size you need
            
            // myLabel.backgroundColor = [UIColor blackColor];
            [myLabel setFont:[UIFont systemFontOfSize:12]];
            
            myLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
            myLabel.textColor = [UIColor whiteColor];
            myLabel.textAlignment = NSTextAlignmentCenter;
            myLabel.text = [NSString stringWithFormat:@"%@  %@",tag.tagId.user.firstName,tag.tagId.user.lastName] ;
            myLabel.center = CGPointMake([tag.originX floatValue], [tag.originY floatValue]);
            [cell.image addSubview:myLabel];
            
        }
        
        self.counter = 1;
        
        
    }
    else{
        
        NSLog(@"%d",self.counter);
        self.counter = 0;
        
        for (id child in [cell.image subviews])
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
        s = @"s ago";
    }
    else
    {
        s=@" ago";
    }
    
    
    //return [dateTime formattedAsTimeAgo];
    return [NSString stringWithFormat:@"%d %@%@", timeAgo,([scale isEqualToString:@"hr"])?@"hour" : scale , s];
}

-(void)downloadClick:(UIButton*)sender
{
//    
//    self.alertDownload = [[UIAlertView alloc] initWithTitle:@"Download Picture"
//                                                    message:@"Download the picture in your iPhone."
//                                                   delegate:self
//                                          cancelButtonTitle:@"Cancel"
//                                          otherButtonTitles:@"Download", nil];

    self.alertDownload =   [UIAlertController
                          alertControllerWithTitle:@"Download Picture"
                          message:@"Download the picture in your iPhone."
                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Download"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
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

                             
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self.alertDownload dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [self.alertDownload addAction:ok];
    [self.alertDownload addAction:cancel];
    self.alertDownload.view.tintColor = [UIColor orangeColor];
    [self presentViewController:self.alertDownload animated:YES completion:nil];

    
    
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
                             
                             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
                             WallPost *data = self.myObject[indexPath.row];
                             
                             NSLog(@"post id: %d",data.id);
                             NSDictionary *inventory = @{ @"wall_post_id" : [NSString stringWithFormat:@"%d",data.id] };
                             if (data.owner.id == self.app.authCredential.id) {
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

}




- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    
    if (alertView == self.alertDownload) {
        
        if (buttonIndex == 1)
        {
            
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
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
    
    
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    NSLog(@"constant %f",self.heightConstraint.constant);
    if (scrollOffset == 0)
    {
        [self.topView removeFromSuperview];
        
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
     
        
        [self changeHeight:48];
        [self changeTop:0];
       
        
    }
    else if(scrollOffset>2)
    {
        
        //[[self navigationController] setNavigationBarHidden:YES animated:YES];
        //[self.view addSubview:_topView];
       
        
           [self changeHeight:48-(scrollView.contentOffset.y)];
            self.parentOfPhotoview.frame = CGRectMake(0, -scrollView.contentOffset.y, self.parentOfPhotoview.frame.size.width, self.heightConstraint.constant);
            self.parentOfPhotoview.backgroundColor = [UIColor whiteColor];
            [self changeTop:-14];
        
        


        
    }
    
    else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        // then we are at the end
    }
    
    
    
    
    
    if(y > h + reload_distance) {
        
        
        if(self.isData && self.loaded)
        {
            
            self.loaded = false;
            [self getData:self.offset];
            
            NSLog(@"load more rows");
            
        }
        
        
    }
    
}


- (void)changeHeight:(CGFloat )height {
    self.heightConstraint.constant = height;
    
    [self.view layoutIfNeeded];
    
}

-(void)changeTop:(CGFloat)height{
    
    self.topOfTableData.constant = height;
    [self.view layoutIfNeeded];
    
    
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
        data.index  = (int)sender.tag;
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
        NSLog(@"timeline response: %@",data);
        
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
            
            self.toast.text = @"The post is successfully deleted";
            self.toast.hidden = NO;
            [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                // Animate the alpha value of your imageView from 1.0 to 0.0 here
                self.toast.alpha = 0.9f;
                
            } completion:^(BOOL finished) {
                // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
                self.toast.hidden = YES;
                
                
            }];

            
            
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
