//
//  SharePhotoViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/2/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "SharePhotoViewController.h"
#import "EditPhotoViewController.h"
#import "ToastView.h"
#import "Contact.h"
#import "TagViewController.h"
#import "ApiAccess.h"
#import "EffectsCollectionViewCell.h"
#import "UIImage+Scale.h"

@interface SharePhotoViewController ()

@end

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
    [self.comment addTarget:self action:@selector(updateLabelUsingContentsOfTextField:) forControlEvents:UIControlEventEditingChanged];
    
    
  
    self.comment.delegate = self;
    
    UITapGestureRecognizer *fbTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabOnFbView:)];
    tapped.numberOfTapsRequired = 1;
    [self.facebookShare addGestureRecognizer:fbTapped];
    fbTapped.cancelsTouchesInView = NO;
   
    self.collectionData.delegate = self;
    self.collectionData.dataSource = self;
    UICollectionViewFlowLayout *layout = (id) self.collectionData.collectionViewLayout;
    layout.itemSize = self.collectionData.frame.size;
     self.collectionData.userInteractionEnabled = YES;
  
   
    
}


-(void)tabOnFbView : (id) sender
{
//     NSLog(@"Hellooooooo");
//    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
//    photo.image = self.image;
//    photo.caption = self.comment.text;
//    photo.userGenerated = YES;
//    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
//    content.photos = @[photo];
//    
//    [FBSDKShareDialog showFromViewController:self
//                                 withContent:content
//                                    delegate:self];
    
    
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
    
    if(self.place)
    {
        self.locationLabel.text = [NSString stringWithFormat:@"%@",self.place.name];
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
   
    static NSString *CellIdentifier = @"photoCell";
    EffectsCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
   

    cell.image.image = [[[self.smilyObject objectAtIndex:indexPath.row] valueForKey:@"image"]scaleToSize:CGSizeMake(50.0, 50.0)];
    
    cell.title.text = [[self.smilyObject objectAtIndex:indexPath.row] valueForKey:@"title"];
 
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor blueColor];
    
   
    NSMutableDictionary *te =[self.smilyObject objectAtIndex:indexPath.row];
    self.wallPostMood =[te objectForKey:@"title"];
     NSLog(@"%@",[te objectForKey:@"title"] );
   // self.wallPostMood =[self.smilyObject objectAtIndex:indexPath.row];
}
- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.comment resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)upload:(id)sender {
    
    [self.loading startAnimating];
    [self.comment resignFirstResponder];
    [self.upload setEnabled:false];
   
    NSString *taglist= @"";
    
    NSLog(@"TagList size: %d",self.myObjectSelection.count);
    
    if(self.myObjectSelection.count>0)
    {
    
        for (int i=0; i<self.myObjectSelection.count; i++) {
            
            Contact *data = self.myObjectSelection[i];
            
            taglist = (i==0) ? [NSString stringWithFormat:@"[%d",data.id] : [NSString stringWithFormat:@"%@,%d",taglist,data.id];
        }
        
        taglist = [NSString stringWithFormat:@"%@]",taglist];
    }
    
    NSLog(@"TAGLIST %@",taglist);
    
    self.comment.text = [NSString stringWithFormat:@"%@ ",self.comment.text];
    
    NSDictionary *inventory = @{
                                @"description" : self.comment.text,
                                @"photo" : [self imageToString:self.image],
                                @"type" : @"0",
                                @"tagged_list" : taglist,
                                @"places" : (self.place)?self.place.toJSONString:@"",
                                @"wall_post_mood":[self.wallPostMood length ]!=0 ?self.wallPostMood:@"",
                                @"Content-Type" : @"charset=utf-8",
                                };
    NSLog(@"%@",inventory);
    
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
        
    }
    
}


- (void)updateLabelUsingContentsOfTextField:(id)sender {
    
    self.descriptionCharLabel.text = [NSString stringWithFormat:@"250/%lu", ((UITextField *)sender).text.length];
    
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
   
    
    NSUInteger oldLength = [textField.text length]; NSUInteger replacementLength = [string length]; NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 250 || returnKey;
    
    
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



@end
