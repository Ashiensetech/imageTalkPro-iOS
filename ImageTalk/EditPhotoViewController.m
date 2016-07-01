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
#import <QuartzCore/QuartzCore.h>

#define SHOW_PREVIEW NO



#ifndef CGWidth
#define CGWidth(rect)                   rect.size.width
#endif

#ifndef CGHeight
#define CGHeight(rect)                  rect.size.height
#endif

#ifndef CGOriginX
#define CGOriginX(rect)                 rect.origin.x
#endif

#ifndef CGOriginY
#define CGOriginY(rect)                 rect.origin.y
#endif

@interface EditPhotoViewController ()<ZDStickerViewDelegate>



@end

@implementation EditPhotoViewController
@synthesize imageCropper;
@synthesize preview;
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
    [self.cropperImage setOriginalImage: self.image ];
    [self.view sendSubviewToBack:self.cropView];
    [self.cropView addSubview:self.adjustFitBtn];
    
    
    //Scroll Scale
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scale-2.png"]] ;
    tempImageView.frame = CGRectMake(self.scroller.bounds.origin.x, self.scroller.bounds.origin.y, tempImageView.image.size.width, tempImageView.image.size.height);//self.scroller.bounds;
    self.scaleImage = tempImageView;
    
    [_scroller setShowsHorizontalScrollIndicator:NO];
    [_scroller setShowsVerticalScrollIndicator:NO];
    _scroller.backgroundColor = [UIColor blackColor];
    _scroller.minimumZoomScale = 1.0  ;
    _scroller.maximumZoomScale = self.scaleImage.image.size.width / _scroller.frame.size.width;
    _scroller.zoomScale = 1.0;
    _scroller.delegate = self;
    
    [_scroller addSubview:self.scaleImage];
    _scroller.decelerationRate = UIScrollViewDecelerationRateFast;
    
    [self.scroller setHidden:YES];
    
    self.pointer= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lg-color.png"]] ;
    _pointer.frame = CGRectMake(self.view.center.x, self.view.center.y+79 , 2.5, _pointer.image.size.height);
    
    [self.view addSubview:_pointer];
    [_pointer setHidden:YES];
    
    //Rotated Image
    
    self.rotatedImage = self.image;
    
    //sticker
    stickerArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    //orientation Button
    [self.orientationBtn setHidden:YES];
    
    
    
}
- (IBAction)orientationChangeAction:(id)sender {
    UIImage *originalImage = self.imageCropper.image;
    UIImage *imageToDisplay = NULL;
    switch (originalImage.imageOrientation) {
        case UIImageOrientationUp: //Left
            imageToDisplay =
            [UIImage imageWithCGImage:[originalImage CGImage]
                                scale:[originalImage scale]
                          orientation: UIImageOrientationLeft];
            break;
        case UIImageOrientationDown: //Right
            imageToDisplay =
            [UIImage imageWithCGImage:[originalImage CGImage]
                                scale:[originalImage scale]
                          orientation: UIImageOrientationRight];
            
            NSLog(@"Down");
            
            break;
        case UIImageOrientationLeft: //Down
            imageToDisplay =
            [UIImage imageWithCGImage:[originalImage CGImage]
                                scale:[originalImage scale]
                          orientation: UIImageOrientationDown];
            NSLog(@"Left");
            
            break;
        case UIImageOrientationRight: //Up
            imageToDisplay =
            [UIImage imageWithCGImage:[originalImage CGImage]
                                scale:[originalImage scale]
                          orientation: UIImageOrientationUp];
            NSLog(@"Right");
            break;
        default:
            break;
    }
    
    [self.imageCropper setImage:imageToDisplay];
}

- (IBAction)effect:(id)sender {
    if(self.type ==1){
        
        self.image = [self.imageCropper getCroppedImage];
        self.thumbImage = [self.image scaleImageToSize:CGSizeMake(80.0, 80.0)];
        [self setCollectionData];
        [self.imageCropper removeFromSuperview];
        [self.cropView addSubview:self.cropperImage];
        [self.cropperImage setOriginalImage:self.image];
        [self.cropperImage setOriginalImage:[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)]];
        
    }
    [self.orientationBtn setHidden:YES];
    [_pointer setHidden:YES];
    [self.scroller setHidden:YES];
    [self.cropView addSubview:self.adjustFitBtn];
    [self.cropView bringSubviewToFront:self.adjustFitBtn];
    [self.adjustFitBtn setHidden:NO];
    
    self.type = 0;
    [self changeType];
}

- (IBAction)lips:(id)sender {
    [self.orientationBtn setHidden:NO];
    [self.view bringSubviewToFront:self.orientationBtn];
    [self.scroller.superview addSubview:self.scroller];
    CGSize scrollableSize = CGSizeMake(self.scaleImage.image.size.width, self.scaleImage.image.size.height/2);
    [_scroller setContentSize:scrollableSize];
    [_scroller setContentOffset:CGPointMake(self.scaleImage.image.size.width/4+55.5, 0)];
    [self.scroller setHidden:NO];
    [_pointer setHidden:NO];
    self.type = 1;
    [self changeType];
    
    [self callBJImageCropper];
    
}

- (IBAction)smily:(id)sender {
    if(self.type ==1){
        self.image= [self.imageCropper getCroppedImage];
        [self.imageCropper removeFromSuperview];
        [self.cropView addSubview:self.cropperImage];
        //        [self.cropperImage setOriginalImage:self.image];
        [self.cropperImage setOriginalImage:[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)]];
    }
    [self.orientationBtn setHidden:YES];
    [_pointer setHidden:YES];
    [self.scroller setHidden:YES];
    [self.adjustFitBtn setHidden:YES];
    self.type = 2;
    [self changeType];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    
    if(translation.x > 0)
    {
        self.lastScrollDirection = 1;
        // react to dragging right
    } else
    {
        self.lastScrollDirection = 2;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([scrollView isEqual: self.scroller]&&self.type==1){
        if (self.lastContentOffset > scrollView.contentOffset.x)
            self.currentScrollDirection = 1; //Right
        else if (self.lastContentOffset < scrollView.contentOffset.x)
            self.currentScrollDirection = 2;//Left
        else if(self.lastContentOffset == scrollView.contentOffset.x)
            self.currentScrollDirection = 0;
        
        self.lastContentOffset = scrollView.contentOffset.x;
        CGFloat radians =0.0;
        CGFloat zoomScale = 0.0;
        NSLog(@"last content : %f",self.lastContentOffset);
        radians = (self.lastContentOffset-237)/302;
        if(self.lastContentOffset >237){
            zoomScale = (self.lastContentOffset-237);
        }else{
            zoomScale = (237-self.lastContentOffset);
        }
        
         NSLog(@"zoomscale : %f",zoomScale);
        UIView *rotatedViewBox =[[UIView alloc] initWithFrame:CGRectMake(0,0,self.image.size.width/1.5, self.image.size.height/1.5)];
        
        
        CGAffineTransform t = CGAffineTransformMakeRotation(radians);//radians
        rotatedViewBox.transform = t;
        CGSize rotatedSize = rotatedViewBox.frame.size;
        UIGraphicsBeginImageContext(rotatedSize);
        CGContextRef bitmap = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
        CGContextRotateCTM(bitmap,radians );
        CGContextScaleCTM(bitmap, 1.0, -1.0);
        CGContextDrawImage(bitmap, CGRectMake(-self.image.size.width/ 2, -self.image.size.height/ 2, self.image.size.width+50, self.image.size.height+50), [self.image CGImage]);
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        if(zoomScale <2){
            self.rotatedImage = self.image;
        }else{
             self.rotatedImage =  [self croppedImageWithImage:newImage zoom:1.5];
        }
        UIGraphicsEndImageContext();
        [self.imageCropper setImage:self.rotatedImage];
        CGRect imagePosition  = [self imagePositionInImageView: self.imageCropper];
        [self.imageCropper setCropViewPosition:imagePosition.origin.x y:imagePosition.origin.y  width:imagePosition.size.width height:imagePosition.size.height];
      
    }
}
-(UIImage*)croppedImageWithImage:(UIImage *)image zoom:(CGFloat)zoom
{
    CGFloat zoomReciprocal = 1.0f / zoom;
    
    CGPoint offset = CGPointMake(image.size.width * ((1.0f - zoomReciprocal) / 2.0f), image.size.height * ((1.0f - zoomReciprocal) / 2.0f));
    CGRect croppedRect = CGRectMake(offset.x, offset.y, image.size.width * zoomReciprocal, image.size.height * zoomReciprocal);
    
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect([image CGImage], croppedRect);
    
    UIImage* croppedImage = [[UIImage alloc] initWithCGImage:croppedImageRef scale:[image scale] orientation:[image imageOrientation]];
    
    CGImageRelease(croppedImageRef);
    
    return croppedImage;
}


-(void)changeType
{
    
    [self.effectBtn setImage:((self.type == 0) ? [UIImage imageNamed:@"FilterIconSelected"] : [UIImage imageNamed:@"FilterIcon"]) forState:UIControlStateNormal];
    [self.lipsBtn setImage:((self.type == 1) ? [UIImage imageNamed:@"ResizeIconSelected"] : [UIImage imageNamed:@"ResizeIcon"]) forState:UIControlStateNormal];
    [self.smilyBtn setImage:((self.type == 2) ? [UIImage imageNamed:@"EmoIconSelected"] : [UIImage imageNamed:@"EmoIcon"]) forState:UIControlStateNormal];
    [self.collectionData reloadData];
}


-(void) viewDidAppear:(BOOL)animated
{
    [[ApiAccess getSharedInstance] setDelegate:self];
    [self setCollectionData];
    
    
}
-(void) setCollectionData{
    self.effectObject = [[NSMutableArray alloc] initWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Original",@"title",self.thumbImage,@"image", nil],
                         
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Marsh",@"title",[self.thumbImage e1],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Chill",@"title",[self.thumbImage e2],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Sunny",@"title",[self.thumbImage e3],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Black & White",@"title",[self.thumbImage e4],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Sun Barn",@"title",[self.thumbImage e5],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Helio",@"title",[self.thumbImage e6],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Sweet Charm",@"title",[self.thumbImage e7],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Katholic",@"title",[self.thumbImage e8],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Bluelin",@"title",[self.thumbImage e9],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Safia",@"title",[self.thumbImage e10],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"1958",@"title",[self.thumbImage e11],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Moonlight",@"title",[self.thumbImage e12],@"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Watermalon",@"title",[self.thumbImage e13],@"image", nil],
                         nil];
    
    self.borderObject = [[NSMutableArray alloc]init];
    
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
        if(stickerArray.count>0){
            UIImage *stickeredImage =(!self.isAspect) ? [self.cropperImage processedImage] : self.image;
            for(int i=0 ; i<stickerArray.count ;i++){
                ZDStickerView *sticker = stickerArray[i];
                CGFloat radians = atan2f(sticker.transform.b, sticker.transform.a);
                [sticker setHidden:YES];
                [((UIImageView*)sticker.contentView) becomeFirstResponder];
                UIImage *bottomImage =  stickeredImage;//background image
                UIImage *image       = NULL;
                
                if(sticker.tag ==0){
                    image =[self imageRotatedByDegrees:radians Image:[UIImage imageNamed:@"glass"]];
                }else if(sticker.tag ==1){
                    image =[self imageRotatedByDegrees:radians Image:[UIImage imageNamed:@"sleepy"]];
                }else if(sticker.tag ==2){
                    image =[self imageRotatedByDegrees:radians Image:[UIImage imageNamed:@"WINK"]];
                }else if(sticker.tag ==3){
                    image =[self imageRotatedByDegrees:radians Image:[UIImage imageNamed:@"wink2"]];
                }
                
                
                CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height);
                
                UIGraphicsBeginImageContext( newSize );
                
                [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
                
                [image drawInRect:CGRectMake(sticker.frame.origin.x+5, sticker.frame.origin.y+5, sticker.frame.size.width-20, sticker.frame.size.height-20)
                        blendMode:kCGBlendModeNormal alpha:1.0];
                
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
                stickeredImage= newImage;
                
            }
            self.image = stickeredImage;
            
        }
        UIImage *img =  [[UIImage alloc]init ];
        if(self.type==1){
           img = [[self.imageCropper getCroppedImage] scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)];
        }else if(stickerArray.count>0){
         img  = self.image;
            
        }
        else{
            img = (!self.isAspect) ? [self.cropperImage processedImage] : self.image;
        }
        NSDictionary *inventory = @{@"photo" : [self imageToString:img]};
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
        return self.effectObject.count;
        //  return self.borderObject.count;
    }
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.view addSubview:self.loading];
    
    
    
    
    if (self.type == 0) {
        self.loading.hidden = NO;
        
        [  self.loading startAnimating];
        
        //   [self performSelector:@selector(saveClicked) withObject:nil afterDelay:0.1];
        
        [self.view bringSubviewToFront:  self.loading];
        
        
        UIImage * convertImage = self.image;
        
        switch (indexPath.row) {
            case 0:
                convertImage= self.imageHolder;
                break;
            case 1:
                convertImage = [self.image e1];
                break;
            case 2:
                convertImage = [self.image e2];
                break;
            case 3:
                convertImage = [self.image e3];
                break;
            case 4:
                convertImage= [self.image e4];
                break;
            case 5:
                convertImage = [self.image e5];
                break;
            case 6:
                convertImage = [self.image e6];
                break;
            case 7:
                convertImage = [self.image e7];
                break;
            case 8:
                convertImage = [self.image e8];
                break;
            case 9:
                convertImage = [self.image e9];
                break;
            case 10:
                convertImage= [self.image e10];
                break;
            case 11:
                convertImage = [self.image e11];
                break;
            case 12:
                convertImage = [self.image e12];
                break;
            case 13:
                convertImage = [self.image e13];
                break;
            default:
                break;
        }
        if(self.isAspect){
            [self.cropperImage setOriginalImage:[convertImage scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)]];
        }else{
            [self.cropperImage setOriginalImage:convertImage ];
        }
        [self.loading stopAnimating];
        
    }
    if(self.type ==1){
        self.cropView.center = CGPointMake(100.0, 100.0);
        self.cropView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    if(self.type ==2){
        switch (indexPath.row) {
            case 0:
                [ self setSticker:[UIImage imageNamed:@"glass"] IndexRow:(int)indexPath.row];
                self.stickered = YES;
                break;
            case 1:
                [ self setSticker:[UIImage imageNamed:@"sleepy"]IndexRow:(int)indexPath.row];
                self.stickered = YES;
                break;
            case 2:
                [ self setSticker:[UIImage imageNamed:@"WINK"]IndexRow:(int)indexPath.row];
                self.stickered = YES;
                break;
            case 3:
                [ self setSticker:[UIImage imageNamed:@"wink2"]IndexRow:(int)indexPath.row];
                self.stickered = YES;
                break;
            default:
                break;
        }
        
    }
    
    if (self.type == 3) {
        
    }
    
}
-(void) setSticker:(UIImage *)sticker  IndexRow: (int) row{
    UIImageView *stickerView = [[UIImageView alloc]
                                initWithImage: sticker];
    CGRect stickerFrame = CGRectMake(50, 50, 140, 140);
    
    UIView* contentView = [[UIView alloc] initWithFrame:stickerFrame];
    
    [contentView addSubview:stickerView];
    
    ZDStickerView *userResizableView1 = [[ZDStickerView alloc] initWithFrame:stickerFrame];
    userResizableView1.tag = row;
    userResizableView1.index =(int) stickerArray.count;
    userResizableView1.stickerViewDelegate = self;
    userResizableView1.contentView = contentView;//contentView;
    userResizableView1.preventsPositionOutsideSuperview = YES;
    userResizableView1.translucencySticker = NO;
    userResizableView1.preventsCustomButton = NO;
    //    [userResizableView1 setButton:ZDSTICKERVIEW_BUTTON_CUSTOM
    //                           image:[UIImage imageNamed:@"tick-icon.png"]];
    
    [userResizableView1 showEditingHandles];
    [self.cropView addSubview:userResizableView1];
    [stickerArray addObject:userResizableView1];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"photoCell";
    
    NSLog(@"%d",self.type);
    
    EffectsCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (self.type == 0) {
        cell.image.image = [[self.effectObject objectAtIndex:indexPath.row] valueForKey:@"image"];
        cell.title.text = [[self.effectObject objectAtIndex:indexPath.row] valueForKey:@"title"];
    }
    else if (self.type == 1) {
        cell.image.image = [[self.lipsObject objectAtIndex:indexPath.row] valueForKey:@"image"];
        cell.image.layoutMargins = UIEdgeInsetsMake(0.0, 0.0,10,0);
        cell.title.text = @"";
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
    
    if (self.isAspect)
    {
       
        [self.cropperImage setOriginalImage:[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)] ];
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


- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees Image:(UIImage *) image
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, degrees);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"count : %ld",stickerArray.count);
    if(stickerArray.count>0){
        UIImage *stickeredImage =(!self.isAspect) ? [self.cropperImage processedImage] : self.image;
        for(int i=0 ; i<stickerArray.count ;i++){
            ZDStickerView *sticker = stickerArray[i];
            CGFloat radians = atan2f(sticker.transform.b, sticker.transform.a);
            [sticker setHidden:YES];
            [((UIImageView*)sticker.contentView) becomeFirstResponder];
            UIImage *bottomImage =  stickeredImage;//background image
            UIImage *image       = NULL;
            
            if(sticker.tag ==0){
                image =[self imageRotatedByDegrees:radians Image:[UIImage imageNamed:@"glass"]];
            }else if(sticker.tag ==1){
                image =[self imageRotatedByDegrees:radians Image:[UIImage imageNamed:@"sleepy"]];
            }else if(sticker.tag ==2){
                image =[self imageRotatedByDegrees:radians Image:[UIImage imageNamed:@"WINK"]];
            }else if(sticker.tag ==3){
                image =[self imageRotatedByDegrees:radians Image:[UIImage imageNamed:@"wink2"]];
            }
            
            
            CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height);
            
            UIGraphicsBeginImageContext( newSize );
            
            [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            
            [image drawInRect:CGRectMake(sticker.frame.origin.x+5, sticker.frame.origin.y+5, sticker.frame.size.width-20, sticker.frame.size.height-20)
                    blendMode:kCGBlendModeNormal alpha:1.0];
            
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            stickeredImage= newImage;
            
        }
        self.image = stickeredImage;
        
    }
    
    if ([segue.identifier isEqualToString:@"sharePhoto"])
    {
        
        SharePhotoViewController *data = [segue destinationViewController];
        //  data.image = self.body.image;
        if(self.type==1){
            data.image = [[self.imageCropper getCroppedImage] scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)];
        }else if(stickerArray.count>0){
            data.image = self.image;
            
        }
        else{
            data.image = (!self.isAspect) ? [self.cropperImage processedImage] : self.image;
        }
        
        
    }
    
    if ([segue.identifier isEqualToString:@"profileShow"])
    {
        NSLog(@"called");
        UINavigationController *navController = [segue destinationViewController];
        ProfileViewController *data = (ProfileViewController *)([navController viewControllers][0]);
        
        if(self.type==1){
            data.pic = [[self.imageCropper getCroppedImage] scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)];
        }else if(stickerArray.count>0){
            data.pic = self.image;
            
        }
        else{
            data.pic = (!self.isAspect) ? [self.cropperImage processedImage] : self.image;
        }
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
    NSLog(@"closed");
    [stickerArray removeObjectAtIndex:sticker.index];
}

- (void)stickerViewDidCustomButtonTap:(ZDStickerView *)sticker
{
    
}

- (void)stickerViewDidBeginEditing:(ZDStickerView *)sticker{
    NSLog(@"begin : %f",sticker.contentView.frame.size.width);
}

- (void)stickerViewDidEndEditing:(ZDStickerView *)sticker{
    NSLog(@"end : %f",sticker.contentView.frame.size.width);
    NSLog(@"%@",sticker.subviews);
}

#pragma mark - BJImageCropper

- (void)updateDisplay {
    
    if (SHOW_PREVIEW) {
        self.preview.image = [self.imageCropper getCroppedImage];
        self.preview.frame = CGRectMake(10,10,self.imageCropper.crop.size.width * 0.1, self.imageCropper.crop.size.height * 0.1);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.imageCropper] && [keyPath isEqualToString:@"crop"]) {
        NSLog(@"Hello");
        [self updateDisplay];
    }
}
-(void) callBJImageCropper{
    self.cropView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tactile_noise.png"]];
    if(self.imageCropper ==NULL){
        UIImage * original = [self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.height)] ;
        self.imageCropper = [[BFCropInterface alloc]initWithFrame:self.cropView.bounds andImage:original nodeRadius:50];//
        self.imageCropper.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.60];
        self.imageCropper.borderColor = [UIColor whiteColor];
        self.imageCropper.borderWidth = 3.0;
        self.imageCropper.showNodes = YES;
        self.imageCropper.center = self.cropView.center;
        CGRect imagePosition  = [self imagePositionInImageView: self.imageCropper];
        self.imageCropper.frame =imagePosition;
        [self.imageCropper setCropViewPosition:imagePosition.origin.x y:imagePosition.origin.y width:imagePosition.size.width height:imagePosition.size.height];
        
    }
    [self.adjustFitBtn setHidden:YES];
    [self.view sendSubviewToBack:self.cropView];
    [self.cropperImage removeFromSuperview];
    [self.cropView addSubview:self.imageCropper];
   
    
    
}
- (CGRect) imagePositionInImageView:(UIImageView*)imageView
{
    float x = 0.0f;
    float y = 0.0f;
    float w = 0.0f;
    float h = 0.0f;
    CGFloat ratio = 0.0f;
    CGFloat horizontalRatio = imageView.frame.size.width / imageView.image.size.width;
    CGFloat verticalRatio = imageView.frame.size.height / imageView.image.size.height;
    
    switch (imageView.contentMode) {
        case UIViewContentModeScaleToFill:
            w = imageView.frame.size.width;
            h = imageView.frame.size.height;
            break;
        case UIViewContentModeScaleAspectFit:
            // contents scaled to fit with fixed aspect. remainder is transparent
            ratio = MIN(horizontalRatio, verticalRatio);
            w = imageView.image.size.width*ratio;
            h = imageView.image.size.height*ratio;
            x = (horizontalRatio == ratio ? 0 : ((imageView.frame.size.width - w)/2));
            y = (verticalRatio == ratio ? 0 : ((imageView.frame.size.height - h)/2));
            break;
        case UIViewContentModeScaleAspectFill:
            // contents scaled to fill with fixed aspect. some portion of content may be clipped.
            ratio = MAX(horizontalRatio, verticalRatio);
            w = imageView.image.size.width*ratio;
            h = imageView.image.size.height*ratio;
            x = (horizontalRatio == ratio ? 0 : ((imageView.frame.size.width - w)/2));
            y = (verticalRatio == ratio ? 0 : ((imageView.frame.size.height - h)/2));
            break;
        case UIViewContentModeCenter:
            // contents remain same size. positioned adjusted.
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            x = (imageView.frame.size.width - w)/2;
            y = (imageView.frame.size.height - h)/2;
            break;
        case UIViewContentModeTop:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            x = (imageView.frame.size.width - w)/2;
            break;
        case UIViewContentModeBottom:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            y = (imageView.frame.size.height - h);
            x = (imageView.frame.size.width - w)/2;
            break;
        case UIViewContentModeLeft:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            y = (imageView.frame.size.height - h)/2;
            break;
        case UIViewContentModeRight:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            y = (imageView.frame.size.height - h)/2;
            x = (imageView.frame.size.width - w);
            break;
        case UIViewContentModeTopLeft:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            break;
        case UIViewContentModeTopRight:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            x = (imageView.frame.size.width - w);
            break;
        case UIViewContentModeBottomLeft:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            y = (imageView.frame.size.height - h);
            break;
        case UIViewContentModeBottomRight:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            y = (imageView.frame.size.height - h);
            x = (imageView.frame.size.width - w);
        default:
            break;
    }
    return CGRectMake(x, y, w, h);
}



- (void)viewDidUnload
{
    [self setImageCropper:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    //  [self.imageCropper removeObserver:self forKeyPath:@"crop"];
}

/*-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 if([scrollView isEqual: self.scroller] && self.type ==1){
 if (!decelerate) {
 [self stoppedScrolling];
 }
 }
 }
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
 {
 if([scrollView isEqual: self.scroller] && self.type ==1){
 [self stoppedScrolling];
 }
 }
 
 
 
 - (void)stoppedScrolling
 {
 NSLog(@"last : %d ,Current : %d",self.lastScrollDirection,self.currentScrollDirection);
 [self.imageCropper setCropViewPosition:50 y:30 width:250 height:250];
 CGFloat radians =0.0;
 radians = (self.lastContentOffset-237)/302;
 UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.image.size.width/1.5, self.image.size.height/1.5)];
 CGAffineTransform t = CGAffineTransformMakeRotation(radians);//radians
 rotatedViewBox.transform = t;
 CGSize rotatedSize = rotatedViewBox.frame.size;
 
 // Create the bitmap context
 UIGraphicsBeginImageContext(rotatedSize);
 CGContextRef bitmap = UIGraphicsGetCurrentContext();
 
 // Move the origin to the middle of the image so we will rotate and scale around the center.
 CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
 
 //   // Rotate the image context
 CGContextRotateCTM(bitmap,radians );//radians
 
 // Now, draw the rotated/scaled image into the context
 CGContextScaleCTM(bitmap, 1.0, -1.0);
 
 CGContextDrawImage(bitmap, CGRectMake(-self.image.size.width / 2, -self.image.size.height / 2, self.image.size.width+5, self.image.size.height+5), [self.image CGImage]);
 UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
 self.rotatedImage = newImage;
 UIGraphicsEndImageContext();
 
 [self.imageCropper setImage:self.rotatedImage];
 [self.imageCropper setCrop:CGRectMake(0,0 , self.rotatedImage.size.width, self.rotatedImage.size.width)];
 
 
 }*/





@end
