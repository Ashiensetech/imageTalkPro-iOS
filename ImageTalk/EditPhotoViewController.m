//
//  EditPhotoViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/2/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "SharePhotoViewController.h"
#import "EditPhotoViewController.h"
#import "ProfileViewController.h"
#import "JSONHTTPClient.h"
#import "ToastView.h"
#import "ApiAccess.h"
#import "EffectsCollectionViewCell.h"
#import "UIImage+Filtrr.h"
#import "UIImage+FiltrrCompositions.h"
#import "UIImage+Scale.h"
#import "UIImage+Border.h"
#import "ZDStickerView.h"



@interface EditPhotoViewController ()<ZDStickerViewDelegate>



@end

@implementation EditPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    self.app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.thumbImage = [self.image scaleToSize:CGSizeMake(80.0, 80.0)];
    self.body.image = self.image;
    self.bodyHeight.constant = self.view.frame.size.width;
    self.type = 0;
    [self changeType];
    self.imageHolder = self.image;
    
    //set adjust fit btn style
    
    self.adjustFitBtn.layer.cornerRadius = 12.0;
    [self.adjustFitBtn.layer setMasksToBounds:YES];
    
    self.adjustFitBtn.frame = CGRectInset(self.adjustFitBtn.frame, -0.5f, -0.5f);
    self.adjustFitBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.adjustFitBtn.layer.borderWidth = 0.5f;
  
    self.cropperImage = [[HIPImageCropperView alloc]
                         initWithFrame:self.cropView.bounds
                         cropAreaSize:CGSizeMake(self.view.frame.size.width,self.view.frame.size.width-20)
                         position:HIPImageCropperViewPositionTop];
    [self.cropView addSubview:self.cropperImage];
    
    [self.cropperImage setOriginalImage:self.image];
    [self.view sendSubviewToBack:self.cropView];
    [self.cropView addSubview:self.adjustFitBtn];
    
}

- (IBAction)effect:(id)sender {
    
    self.type = 0;
    [self changeType];
   
}

- (IBAction)lips:(id)sender {
    
    self.type = 1;
    [self changeType];
  
}

- (IBAction)smily:(id)sender {
    self.type = 2;
    [self changeType];
  
    
}

- (IBAction)frame:(id)sender {
    self.type = 3;
    [self changeType];
    
}

-(void)changeType
{
    
    [self.effectBtn setImage:((self.type == 0) ? [UIImage imageNamed:@"FilterIconSelected"] : [UIImage imageNamed:@"FilterIcon"]) forState:UIControlStateNormal];
    [self.lipsBtn setImage:((self.type == 1) ? [UIImage imageNamed:@"ResizeIconSelected"] : [UIImage imageNamed:@"ResizeIcon"]) forState:UIControlStateNormal];
    [self.smilyBtn setImage:((self.type == 2) ? [UIImage imageNamed:@"EmoIconSelected"] : [UIImage imageNamed:@"EmoIcon"]) forState:UIControlStateNormal];
    [self.frameBtn setImage:((self.type == 3) ? [UIImage imageNamed:@"4a"] : [UIImage imageNamed:@"4"]) forState:UIControlStateNormal];
   
    
    [self.collectionData reloadData];
}


-(void) viewDidAppear:(BOOL)animated
{
    [[ApiAccess getSharedInstance] setDelegate:self];
    
    self.effectObject = [[NSMutableArray alloc] initWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Original",@"title",self.thumbImage,@"image", nil],
                         
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Mir",@"title",[self.thumbImage e1],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Predok",@"title",[self.thumbImage e2],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Derevo",@"title",[self.thumbImage e3],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Temno",@"title",[self.thumbImage e4],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Briana",@"title",[self.thumbImage e5],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Prizrak",@"title",[self.thumbImage e6],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Gothic",@"title",[self.thumbImage e7],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Katholic",@"title",[self.thumbImage e8],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Hidra",@"title",[self.thumbImage e9],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Con",@"title",[self.thumbImage e10],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Tirex",@"title",[self.thumbImage e11],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Willow",@"title",[self.thumbImage e12],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Clarendon",@"title",[self.thumbImage e13],@"image", nil],
                         nil];
    
    self.borderObject = [[NSMutableArray alloc] initWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:@"No Frame",@"title",self.thumbImage,@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Blue",@"title",[self.thumbImage imageWithColoredBorder:10 borderColor:[UIColor blueColor] withShadow:YES],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Green",@"title",[self.thumbImage imageWithColoredBorder:10 borderColor:[UIColor greenColor] withShadow:YES],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Black",@"title",[self.thumbImage imageWithColoredBorder:10 borderColor:[UIColor blackColor] withShadow:YES],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"White",@"title",[self.thumbImage imageWithColoredBorder:10 borderColor:[UIColor whiteColor] withShadow:YES],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Cyan",@"title",[self.thumbImage imageWithColoredBorder:10 borderColor:[UIColor cyanColor] withShadow:YES],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Yellow",@"title",[self.thumbImage imageWithColoredBorder:10 borderColor:[UIColor yellowColor] withShadow:YES],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Purple",@"title",[self.thumbImage imageWithColoredBorder:10 borderColor:[UIColor purpleColor] withShadow:YES],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Orange",@"title",[self.thumbImage imageWithColoredBorder:10 borderColor:[UIColor orangeColor] withShadow:YES],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Gray",@"title",[self.thumbImage imageWithColoredBorder:10 borderColor:[UIColor grayColor] withShadow:YES],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Red",@"title",[self.thumbImage imageWithColoredBorder:10 borderColor:[UIColor redColor] withShadow:YES],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Magenta",@"title",[self.thumbImage imageWithColoredBorder:10 borderColor:[UIColor magentaColor] withShadow:YES],@"image", nil],
                         nil];
    
    self.lipsObject = [[NSMutableArray alloc]init];
    self.smilyObject =[[NSMutableArray alloc]initWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Glass",@"title",[UIImage imageNamed:@"glass"],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Sleepy",@"title",[UIImage imageNamed:@"sleepy"],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Wink",@"title",[UIImage imageNamed:@"WINK"],@"image", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Wink 2",@"title",[UIImage imageNamed:@"wink2"],@"image", nil],
                       nil];
    
    [self.collectionData reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    
    if(self.isTimeline)
    {
         [self performSegueWithIdentifier:@"sharePhoto" sender:self];
    }
    else
    {
       [self.loading startAnimating];
       NSDictionary *inventory = @{@"photo" : [self imageToString:[self.cropperImage processedImage]]};
//        NSLog(@"%@",[self imageToString:[self.cropperImage processedImage]]);
        [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/profile/change/picture" params:inventory tag:@"changePicture"];
    }
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
    
    return [imageData base64EncodedStringWithOptions:0];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    if (self.type == 0) {
         return self.effectObject.count;
    }
    
    else if (self.type == 1) {
         return self.lipsObject.count;
    }
    
    else if (self.type == 2) {
         return self.smilyObject.count;
    }
    
    else{
         return self.borderObject.count;
    }
   
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.view addSubview:self.loading];

    [self.loading startAnimating];
  
    
    if (self.type == 0) {
    
        switch (indexPath.row) {
            case 0:
                if (self.isAspect)
                {
                    self.image = self.imageHolder;
                    [self.cropperImage setOriginalImage:[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)]];
                }
                else
                {
                    self.image = self.imageHolder;
                    [self.cropperImage setOriginalImage:self.image];
                }
                break;
            case 1:
                if (self.isAspect)
                {
                    self.image = [self.image e1];
                    [self.cropperImage setOriginalImage:[[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] e1]];
                }
                else
                {
                    self.image = [self.image e1];
                    [self.cropperImage setOriginalImage:[self.image e1]];
                    
                }
    
                break;
            case 2:
                if (self.isAspect)
                {
                    self.image = [self.image e2];
                    [self.cropperImage setOriginalImage:[[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] e2]];
                }
                else
                {
                    self.image = [self.image e2];
                    [self.cropperImage setOriginalImage:[self.image e2]];
                    
                }
                
                break;
            case 3:
                if (self.isAspect)
                {
                    self.image = [self.image e3];
                    [self.cropperImage setOriginalImage:[[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] e3]];
                }
                else
                {
                    self.image = [self.image e3];
                    [self.cropperImage setOriginalImage:[self.image e3]];
                    
                }
                
                break;
            case 4:
                if (self.isAspect)
                {
                    self.image = [self.image e4];
                    [self.cropperImage setOriginalImage:[[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] e4]];
                }
                else
                {
                    self.image = [self.image e4];
                    [self.cropperImage setOriginalImage:[self.image e4]];
                    
                }
                
                break;
            case 5:
                if (self.isAspect)
                {
                    self.image = [self.image e5];
                    [self.cropperImage setOriginalImage:[[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] e5]];
                }
                else
                {
                    self.image = [self.image e5];
                    [self.cropperImage setOriginalImage:[self.image e5]];
                    
                }
                
                break;
            case 6:
                if (self.isAspect)
                {
                    self.image = [self.image e6];
                    [self.cropperImage setOriginalImage:[[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] e6]];
                }
                else
                {
                    self.image = [self.image e6];
                    [self.cropperImage setOriginalImage:[self.image e6]];
                    
                }
                
                break;
            case 7:
                if (self.isAspect)
                {
                    self.image = [self.image e7];
                    [self.cropperImage setOriginalImage:[[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] e7]];
                }
                else
                {
                    self.image = [self.image e7];
                    [self.cropperImage setOriginalImage:[self.image e7]];
                    
                }
                
                break;
            case 8:
                if (self.isAspect)
                {
                    self.image = [self.image e8];
                    [self.cropperImage setOriginalImage:[[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] e8]];
                }
                else
                {
                    self.image = [self.image e8];
                    [self.cropperImage setOriginalImage:[self.image e8]];
                    
                }
                
                break;
            case 9:
                if (self.isAspect)
                {
                    self.image = [self.image e9];
                    [self.cropperImage setOriginalImage:[[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] e9]];
                }
                else
                {
                    self.image = [self.image e9];
                    [self.cropperImage setOriginalImage:[self.image e9]];
                    
                }
                
                break;
            case 10:
                if (self.isAspect)
                {
                    self.image = [self.image e10];
                    [self.cropperImage setOriginalImage:[[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] e10]];
                }
                else
                {
                    self.image = [self.image e10];
                    [self.cropperImage setOriginalImage:[self.image e10]];
                    
                }
                
                break;
            case 11:
                 if (self.isAspect)
                 {
                     self.image = [self.image e11];
                     [self.cropperImage setOriginalImage:[[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] e11]];
                 }
                 else
                 {
                     self.image = [self.image e11];
                     [self.cropperImage setOriginalImage:[self.image e11]];
                     
                 }
                 
                 break;
            case 12:
                if (self.isAspect)
                {
                    self.image = [self.image e12];
                    [self.cropperImage setOriginalImage:[[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] e12]];
                }
                else
                {
                    self.image = [self.image e12];
                    [self.cropperImage setOriginalImage:[self.image e12]];
                    
                }
                
                break;
            case 13:
                if (self.isAspect)
                {
                    self.image = [self.image e13];
                    [self.cropperImage setOriginalImage:[[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] e13]];
                }
                else
                {
                    self.image = [self.image e13];
                    [self.cropperImage setOriginalImage:[self.image e13]];
                    
                }
                break;
            default:
                break;
                
        }
       
        [self.loading stopAnimating];
    }
    if(self.type ==2){
        switch (indexPath.row) {
            case 0:
               [ self setSticker:[UIImage imageNamed:@"glass"]];
                self.stickered = YES;
                break;
            case 1:
                [ self setSticker:[UIImage imageNamed:@"sleepy"]];
                self.stickered = YES;
                break;
            case 2:
                [ self setSticker:[UIImage imageNamed:@"WINK"]];
                self.stickered = YES;
                break;
            case 3:
                [ self setSticker:[UIImage imageNamed:@"wink2"]];
                self.stickered = YES;
                break;
            default:
                break;
        }
        
    }
    
    if (self.type == 3) {
        

        
        switch (indexPath.row) {
            case 0:
                [self.body setImage:self.image];
                break;
            case 1:
                //[self.body setImage:[self.image imageWithColoredBorder:20 borderColor:[UIColor blueColor] withShadow:YES]];
                [self.body setImage:[self.image imageWithImageBorder:[[UIImage imageNamed:@"frame1"] scaleToSize:CGSizeMake(self.image.size.width*2,self.image.size.height*2)]]];
                break;
            case 2:
                [self.body setImage:[self.image imageWithColoredBorder:20 borderColor:[UIColor greenColor] withShadow:YES]];
                break;
            case 3:
                [self.body setImage:[self.image imageWithColoredBorder:20 borderColor:[UIColor blackColor] withShadow:YES]];
                break;
            case 4:
                [self.body setImage:[self.image imageWithColoredBorder:20 borderColor:[UIColor whiteColor] withShadow:YES]];
                break;
            case 5:
                [self.body setImage:[self.image imageWithColoredBorder:20 borderColor:[UIColor cyanColor] withShadow:YES]];
                break;
            case 6:
                [self.body setImage:[self.image imageWithColoredBorder:20 borderColor:[UIColor yellowColor] withShadow:YES]];
                break;
            case 7:
                [self.body setImage:[self.image imageWithColoredBorder:20 borderColor:[UIColor purpleColor] withShadow:YES]];
                break;
            case 8:
                [self.body setImage:[self.image imageWithColoredBorder:20 borderColor:[UIColor orangeColor] withShadow:YES]];
                break;
            case 9:
                [self.body setImage:[self.image imageWithColoredBorder:20 borderColor:[UIColor grayColor] withShadow:YES]];
                break;
            case 10:
                [self.body setImage:[self.image imageWithColoredBorder:20 borderColor:[UIColor redColor] withShadow:YES]];
                break;
            case 11:
                [self.body setImage:[self.image imageWithColoredBorder:20 borderColor:[UIColor magentaColor] withShadow:YES]];
                break;
            default:
                break;
        }
    }
    [self.loading stopAnimating];
}
-(void) setSticker:(UIImage *)sticker{
    UIImageView *stickerView = [[UIImageView alloc]
                               initWithImage: sticker];
    CGRect stickerFrame = CGRectMake(50, 50, 140, 140);
    
    UIView* contentView = [[UIView alloc] initWithFrame:stickerFrame];
    
    [contentView addSubview:stickerView];
    
    ZDStickerView *userResizableView1 = [[ZDStickerView alloc] initWithFrame:stickerFrame];
    userResizableView1.tag = 0;
    userResizableView1.stickerViewDelegate = self;
    userResizableView1.contentView = contentView;//contentView;
    userResizableView1.preventsPositionOutsideSuperview = YES;
    userResizableView1.translucencySticker = NO;
     userResizableView1.preventsCustomButton = NO;
    [userResizableView1 setButton:ZDSTICKERVIEW_BUTTON_CUSTOM
                           image:[UIImage imageNamed:@"plus"]];
  
    [userResizableView1 showEditingHandles];
    [self.cropView addSubview:userResizableView1];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"photoCell";
    
    NSLog(@"ihdifgs");
    
    EffectsCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (self.type == 0) {
        cell.image.image = [[self.effectObject objectAtIndex:indexPath.row] valueForKey:@"image"];
        cell.title.text = [[self.effectObject objectAtIndex:indexPath.row] valueForKey:@"title"];
    }
    else if (self.type == 1) {
        cell.image.image = [[self.effectObject objectAtIndex:indexPath.row] valueForKey:@"image"];
        cell.title.text = [[self.effectObject objectAtIndex:indexPath.row] valueForKey:@"title"];
    }
    else if (self.type == 2) {
        cell.image.image = [[self.smilyObject objectAtIndex:indexPath.row] valueForKey:@"image"];
        cell.title.text = [[self.smilyObject objectAtIndex:indexPath.row] valueForKey:@"title"];
    }
    
    else{
        cell.image.image = [[self.borderObject objectAtIndex:indexPath.row] valueForKey:@"image"];
        cell.title.text = [[self.borderObject objectAtIndex:indexPath.row] valueForKey:@"title"];
    }
    
    
    return cell;
}
- (IBAction)adjustImageAction:(id)sender {
    self.isAspect = !self.isAspect;
    NSLog(@"Hello");
    
    if (self.isAspect)
    {
       [self.cropperImage setOriginalImage:[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)]];
    }
    else
    {
      //  [self.cropperImage setOriginalImage:[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.height)]];

       [self.cropperImage setOriginalImage:self.image];
        
    }
}

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    [self.loading stopAnimating];
    
    if ([tag isEqualToString:@"changePicture"])
    {
        
        NSError* error = nil;
        self.response = [[ChangePhotoResponse alloc] initWithDictionary:data error:&error];
        if(self.response.responseStat.status){
            self.app.userPic = self.response.responseData.picPath.original.path;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }

    }
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"sharePhoto"])
    {
       
        SharePhotoViewController *data = [segue destinationViewController];
      //  data.image = self.body.image;
        
        data.image = (!self.isAspect) ? [self.cropperImage processedImage] : self.image;

    }
    
    if ([segue.identifier isEqualToString:@"profileShow"])
    {
        UINavigationController *navController = [segue destinationViewController];
        ProfileViewController *data = (ProfileViewController *)([navController viewControllers][0]);
        //data.pic = self.body.image;
        data.pic = (!self.isAspect) ? [self.cropperImage processedImage] : self.image;
    }
}

#pragma mark - delegate functions

- (void)stickerViewDidLongPressed:(ZDStickerView *)sticker
{
    NSLog(@"%s [%zd]",__func__, sticker.tag);
}

- (void)stickerViewDidClose:(ZDStickerView *)sticker
{
    NSLog(@"%s [%zd]",__func__, sticker.tag);
}

- (void)stickerViewDidCustomButtonTap:(ZDStickerView *)sticker
{
    NSLog(@"%s [%zd]",__func__, sticker.tag);
    [((UITextView*)sticker.contentView) becomeFirstResponder];
    UIImage *bottomImage = [self.cropperImage processedImage]; //background image
    UIImage *image       = [UIImage imageNamed:@"glass"];
    CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Apply supplied opacity if applicable
    [image drawInRect:CGRectMake(sticker.contentView.bounds.origin.x, sticker.contentView.bounds.origin.y, sticker.contentView.bounds.size.width, sticker.contentView.bounds.size.height)
            blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    [self.cropperImage setOriginalImage:newImage];
}

@end
