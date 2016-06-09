//
//  SharePhotoViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/2/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SharePhotoViewController.h"
#import "EditPhotoViewController.h"
#import "ToastView.h"
#import "Contact.h"
#import "TagViewController.h"
#import "ApiAccess.h"
#import "EffectsCollectionViewCell.h"
#import "UIImage+Scale.h"
#import "UIImageView+WebCache.h"
#import "JSONHTTPClient.h"
#import <QuartzCore/QuartzCore.h>
#import "VKSdk.h"
#import "VKUploadImage.h"

#import <Accounts/Accounts.h>
#import <Social/Social.h>
@interface SharePhotoViewController ()
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@end
@import  Social;
@implementation SharePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    NSLog(@"%@",self.myObjectSelection);
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    self.mainImage.image = self.image;
    self.mainImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabOnImage:)];
    tapped.numberOfTapsRequired = 1;
    [self.mainImage addGestureRecognizer:tapped];
    tapped.cancelsTouchesInView = NO;
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    singleTap.cancelsTouchesInView = NO;
    
    
    UITapGestureRecognizer *fbTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabOnFbView:)];
    tapped.numberOfTapsRequired = 1;
    [self.facebookShare addGestureRecognizer:fbTapped];
    fbTapped.cancelsTouchesInView = NO;
    
    UITapGestureRecognizer *igTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabonInstagramView:)];
    igTapped.numberOfTapsRequired = 1;
    [self.instagramShare addGestureRecognizer:igTapped];
    igTapped.cancelsTouchesInView = NO;
    
    
    UITapGestureRecognizer *vkTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabOnVKView:)];
    vkTapped.numberOfTapsRequired = 1;
    [self.VKShare addGestureRecognizer:vkTapped];
    vkTapped.cancelsTouchesInView = NO;
    
    
    self.collectionData.delegate = self;
    self.collectionData.dataSource = self;
    self.collectionData.userInteractionEnabled = YES;
    
    self.postCaption.delegate = self;
    self.postCaption.text = @"write your comment here...";
    self.postCaption.textColor = [UIColor lightGrayColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
   
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%@",app.userPic);
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    NSURL *filePath = [NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,app.userPic]];
    NSLog(@"%@",filePath);
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:filePath];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    if(image != NULL)
    {
        NSLog(@"image :%@" ,image);
        self.profilePic = image;
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
                                       NSLog(@"data %@",data);
                                       self.profilePic = [[UIImage alloc]initWithData:data];
                                       
                                   }
                               }];
        
    }
    
}
-(void)dismissKeyboard {
    
    [self.postCaption resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"write your comment here..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
    UIImageView *foreground = [[UIImageView alloc] init];
    foreground.frame = CGRectMake( self.containerScroller.bounds.origin.x, self.containerScroller.bounds.origin.y, self.containerScroller.frame.size.width, self.containerScroller.frame.size.height);
    foreground.backgroundColor = [UIColor blackColor];
    foreground.alpha = 0.6f;
    [self.containerScroller addSubview:foreground];
    self.blackView = foreground;
    self.containerScroller.userInteractionEnabled = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"write your comment here...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [self.postCaption resignFirstResponder];
    [self.blackView removeFromSuperview];
    self.containerScroller.userInteractionEnabled = YES;
}
-(void)textViewDidChangeSelection:(UITextView *)textView{
    if ([textView.text isEqualToString:@"write your comment here..."]) {
        self.descriptionCharLabel.text = [NSString stringWithFormat:@"0/250"];
        
    }else{
        self.descriptionCharLabel.text = [NSString stringWithFormat:@"%u/250", (textView.text.length)];
    }
    
    
}
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSUInteger oldLength = [textView.text length]; NSUInteger replacementLength = [text length]; NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [text rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 250 || returnKey;
}

-(void)tabOnFbView : (id) sender
{
    NSLog(@"Hellooooooo");
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = self.image;
    //photo.caption = self.comment.text;
    [photo setCaption:self.comment.text];
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:self];
    
    
}
-(void)tabonInstagramView:(id) sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"...Do you want to proceed with twitter sharing ?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
 
    
    
}


-(void) tabOnVKView :(id) sender{
    NSLog(@"VKtabbed");
    
    VKSdk *sdkInstance = [VKSdk initializeWithAppId:@"5444705"];
    if(sdkInstance !=NULL){
        NSString * str = [[NSString alloc]init];
        if ([self.postCaption.text  isEqualToString:@"write your comment here..."]) {
            str = @"";
            
        }else{
            str = self.postCaption.text;
        }
        
        VKUploadImage *vk = [[VKUploadImage alloc]init];
        vk.sourceImage = self.image;
        VKShareDialogController *shareDialog = [VKShareDialogController new]; //1
        shareDialog.text         = str;
        shareDialog.uploadImages = @[vk];
        
        [shareDialog setCompletionHandler:^(VKShareDialogController * diaglog, VKShareDialogControllerResult result) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [self presentViewController:shareDialog animated:YES completion:nil]; //6
    }
    
    
}


-(void)tabOnImage :(id) sender
{
    NSLog(@"here");
    UIImageView *fullImage =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    fullImage.image=self.image;
    fullImage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    [self.view addSubview:fullImage];
    [self.view bringSubviewToFront:fullImage];
    fullImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabOnFullImage:)];
    tapped.numberOfTapsRequired = 1;
    tapped.cancelsTouchesInView = NO;
    [fullImage addGestureRecognizer:tapped];
    
    
}

-(void)tabOnFullImage :(id) sender
{
    
    
    for (id child in [self.view subviews])
    {
        if ([child isMemberOfClass:[UIImageView class]])
        {
            [child removeFromSuperview];
        }
    }
    
}


-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"%@",self.myObjectSelection);
    //NSLog(@"%@",[self imageToString:self.image]);
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    
    //    if(self.place)
    //    {
    //        self.locationLabel.text = [NSString stringWithFormat:@"%@",self.place.name];
    //    }
    //    else
    //    {
    //        self.locationLabel.text = @"Add Location";
    //    }
    if(self.postLocation)
    {
        self.locationLabel.text =[NSString stringWithFormat:@"%@",self.postLocation.name];
    }
    else
    {
        self.locationLabel.text = @"Add Location";
    }
    
    if(self.myObjectSelection.count>0)
    {
        
        for (int i=0; i<self.myObjectSelection.count; i++) {
            
            Contact *data = self.myObjectSelection[i];
            
            self.tagLabel.text = (i==0) ? [NSString stringWithFormat:@"%@",data.user.firstName] : [NSString stringWithFormat:@"%@,%@",self.tagLabel.text,data.user.firstName];
        }
        
    }
    else
    {
        self.tagLabel.text = @"Tag Friends";
    }
    
    

    
    
    self.smilyObject =[[NSMutableArray alloc]initWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:@"None",@"title", self.profilePic ,@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Happy",@"title",[[UIImage imageNamed:@"happyL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"In Love",@"title",[[UIImage imageNamed:@"inloveL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Confused",@"title",[[UIImage imageNamed:@"confusedL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Sad",@"title",[[UIImage imageNamed:@"sadL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Beauty",@"title",[[UIImage imageNamed:@"beautyL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Surprised",@"title",[[UIImage imageNamed:@"surpriseL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Angry",@"title",[[UIImage imageNamed:@"angryL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Sleepy",@"title",[[UIImage imageNamed:@"sleepyL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Love",@"title",[[UIImage imageNamed:@"loveL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Hangover",@"title",[[UIImage imageNamed:@"hangoverL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Driving",@"title",[[UIImage imageNamed:@"drivingL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Chilling",@"title",[[UIImage imageNamed:@"chillingL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Eating",@"title",[[UIImage imageNamed:@"eatingL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Workout",@"title",[[UIImage imageNamed:@"workoutL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Movie",@"title",[[UIImage imageNamed:@"movieL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Insomnia",@"title",[[UIImage imageNamed:@"insomiaL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Boozing",@"title",[[UIImage imageNamed:@"boozingL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Coding",@"title",[[UIImage imageNamed:@"codingL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Coffee",@"title",[[UIImage imageNamed:@"coffeeL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Music",@"title",[[UIImage imageNamed:@"musicL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Cooking",@"title",[[UIImage imageNamed:@"cookingL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Gaming",@"title",[[UIImage imageNamed:@"GamingL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Late",@"title",[[UIImage imageNamed:@"lateL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Making",@"title",[[UIImage imageNamed:@"makingL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Middle",@"title",[[UIImage imageNamed:@"middleL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Read",@"title",[[UIImage imageNamed:@"readL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Shopping",@"title",[[UIImage imageNamed:@"ShoppingL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Singing",@"title",[[UIImage imageNamed:@"singingL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Smoking",@"title",[[UIImage imageNamed:@"smokingL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Stuck In Traffic",@"title",[[UIImage imageNamed:@"trafficL.png"] scaleToSize:CGSizeMake(40.0, 40.0)],@"image", nil],
                       
                       nil];
    
    [self.collectionData reloadData];
    
    
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.smilyObject.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.item == 0 && indexPath.item ==0 && indexPath.section == 0){
        
        static NSString *CellIdentifier = @"profilePicCell";
        EffectsCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.image.image = [[self.smilyObject objectAtIndex:indexPath.row] valueForKey:@"image"];
        cell.title.text = [[self.smilyObject objectAtIndex:indexPath.row] valueForKey:@"title"];
        cell.image.layer.backgroundColor=[[UIColor clearColor] CGColor];
        cell.image.layer.cornerRadius=cell.image.frame.size.height;
        cell.image.layer.borderWidth=0.0;
        cell.image.layer.masksToBounds = YES;
        cell.image.layer.borderColor=[[UIColor redColor] CGColor];
        
        if([self.wallPostMood length]==0 || [cell.title.text isEqualToString:self.wallPostMood]){
            cell.title.textColor = [UIColor orangeColor];
        }else{
            cell.title.textColor = [UIColor grayColor];
        }
        
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"photoCell";
        EffectsCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.image.image = [[[self.smilyObject objectAtIndex:indexPath.row] valueForKey:@"image"]scaleToSize:CGSizeMake(50.0, 50.0)];
        cell.title.text = [[self.smilyObject objectAtIndex:indexPath.row] valueForKey:@"title"];
        if([self.wallPostMood length]!=0 && [cell.title.text isEqualToString:self.wallPostMood]){
            cell.title.textColor = [UIColor orangeColor];
        }else{
            cell.title.textColor = [UIColor grayColor];
        }
        
        return cell;
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EffectsCollectionViewCell *efCell = (EffectsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    efCell.title.textColor = [UIColor grayColor];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *te =[self.smilyObject objectAtIndex:indexPath.row];
    self.wallPostMood =[te objectForKey:@"title"];
    NSArray* visibleCellIndex = collectionView.indexPathsForVisibleItems ;
    for(NSIndexPath * path in visibleCellIndex){
        EffectsCollectionViewCell *efCell = (EffectsCollectionViewCell *)[collectionView cellForItemAtIndexPath:path];
        
        if([efCell.title.text isEqualToString:self.wallPostMood]){
            
            efCell.title.textColor = [UIColor orangeColor];
            
        }else{
            efCell.title.textColor = [UIColor grayColor];
        }
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)upload:(id)sender {
  
    
    [self.view addSubview:self.loading];
    self.loading.hidden = NO;
    [self.loading startAnimating];
    [self.postCaption resignFirstResponder];
    [self.upload setEnabled:false];
    
    NSString *taglist= @"";
    NSString *location =@"";
    
//    if(self.postLocation){
//    
//        
//        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject: self.postLocation
//                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                             error:&error];
//        
//        if (! jsonData) {
//            NSLog(@"Got an error: %@", error);
//        } else {
//            location = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            
//        }
//    }
    
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    if(self.tagList.count>0){
        for (int i=0; i<self.tagList.count;i++ ) {
            Contact *çontact = [self.tagList[i] valueForKey:@"owner"];
            
            NSDictionary *dict = @{
                                   @"tag_id" : [NSNumber numberWithInt: çontact.id],
                                   @"origin_x"  :[self.tagList[i] valueForKey:@"origin_x"] ,
                                   @"origin_y"  :[self.tagList[i] valueForKey:@"origin_y"] ,
                                   @"tag_message" : self.tagCustomMessage,
                                   };
            [tags addObject:dict];
        }
        
        NSDictionary * dict1 =@{
                                @"tagged_id_list": tags
                                };
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict1
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            taglist = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
        }
        
    }
    
    NSLog(@"%@",taglist);
    NSString * str = [[NSString alloc]init];
    if ([self.postCaption.text  isEqualToString:@"write your comment here..."]) {
        str = @"";
        
    }else{
        NSData *data = [self.postCaption.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
       str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     //   str = self.postCaption.text;
    }
      NSLog(@"post Caption : %@", str);
    self.postCaption.text = [NSString stringWithFormat:@"%@ ",self.postCaption.text];
    
    NSDictionary *inventory = @{
                                @"description" : str,
                                @"photo" : [self imageToString:self.image],
                                @"type" : @"0",
                                @"tagged_list" : taglist,
                                @"places" : (self.postLocation)?self.postLocation.toJSONString:@"",
                                @"wall_post_mood":[self.wallPostMood length ]!=0 ?self.wallPostMood:@"",
                                @"Content-Type" : @"charset=utf-8",
                                };
    // NSLog(@"%@",inventory);
    
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/create" params:inventory tag:@"getPhoto"];
    
    
}

-(NSString*) imageToString : (UIImage*) image{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
        
    }
    
    return [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    [self.loading stopAnimating];
    
    if ([tag isEqualToString:@"getPhoto"])
    {
        
        
        NSError* error = nil;
        self.response = [[CreatePostResponse alloc] initWithDictionary:data error:&error];
        [self.upload setEnabled:true];
        
        if(self.response.responseStat.status){
            
            [self performSegueWithIdentifier:@"timeline" sender:self];
        }
        
        
    }
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    [self.loading stopAnimating];
    
    if ([tag isEqualToString:@"getPhoto"])
    {
        [self.upload setEnabled:true];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"tag"])
    {
        TagViewController *data = [segue destinationViewController];
        data.pic  = self.image;
        data.type = 0;
        data.myObjectSelection = self.myObjectSelection;
        data.tagPostions = self.tagList;
        data.customMessageString = self.tagCustomMessage;
        
    }
    
}



#pragma mark - Collection view
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}




#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"SETTING SIZE FOR ITEM AT INDEX %d", indexPath.row);
    CGSize mElementSize = CGSizeMake(70, 70);
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

#pragma mark - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"completed share:%@", results);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"sharing error:%@", error);
    NSString *message = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?:
    @"There was a problem sharing, please try again later.";
    NSString *title = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops!";
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"share cancelled");
}

#pragma mark - vk sdk delegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result{
    NSLog(@"Result : %@" ,result);
}
- (void)vkSdkUserAuthorizationFailed{
    NSLog(@"AUthorization Failed  ");
}

#pragma mark - UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        //User clicked ok
        NSLog(@"ok");
        
        
        ACAccountStore *account=[[ACAccountStore alloc]init];
        ACAccountType *accountType=[account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            if (granted==YES) {
                NSArray *arrayOfAccount=[account accountsWithAccountType:accountType];
                if ([arrayOfAccount count]>0) {
                    ACAccount *twitterAccount=[arrayOfAccount lastObject];
                    NSString * str = [[NSString alloc]init];
                    if ([self.postCaption.text  isEqualToString:@"write your comment here..."]) {
                        str = @"";
                        
                    }else{
                        str = self.postCaption.text;
                    }
                    
                    NSDictionary *message = @{@"status": str};
                    NSURL *requestURL = [NSURL
                                         URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"];
                    SLRequest *postRequest = [SLRequest
                                              requestForServiceType:SLServiceTypeTwitter
                                              requestMethod:SLRequestMethodPOST
                                              URL:requestURL parameters:message];
                    // UIImage *image = [self.image];
                    NSData *myData = UIImagePNGRepresentation(self.image);
                    [postRequest addMultipartData:myData withName:@"media" type:@"image/png" filename:@"TestImage"];
                    
                    postRequest.account=twitterAccount;
                    NSLog(@"Post data :%@",postRequest);
                    
                    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        NSMutableDictionary *responseDictionary  = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                        NSLog(@"Response dictionary: %@", responseDictionary);
                        if(error){
                             [ToastView showToastInParentView:self.view withText:@"There was an error sharing to twitter" withDuaration:2.0];
                        }
                        if(responseDictionary){
                           
                                [ToastView showToastInParentView:self.view withText:@"shared to twitter " withDuaration:2.0];
                            
                        }
                    }];
                    
                }
            }
        }];
        
    }
    else
    {
        //User clicked cancel
        NSLog(@"cancel");
    }
}
@end
