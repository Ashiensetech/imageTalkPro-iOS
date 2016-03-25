//
//  AllPhotosViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/2/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "AllPhotosViewController.h"
#import "AssetManager.h"
#import "CustomCollectionViewCell.h"
#import "AdjustPhotoViewController.h"
#import "EditPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface AllPhotosViewController ()

@end

@implementation AllPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;

    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    else
    {
        [self setupCaptureSession];
    }
    
    
    if (!self.assets) {
        _assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }
    
    
    ALAssetsLibrary *al = [AssetManager defaultAssetsLibrary];
    
    
    [al enumerateGroupsWithTypes:ALAssetsGroupAll
                      usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
          {
              if (asset)
              {
                [self.assets addObject:asset];
                
              }
              
          }
          ];
         
         NSLog(@"first    %@",self.assets);
         
         self.assetsR=[[[self.assets reverseObjectEnumerator] allObjects] mutableCopy];
         [self.collectionData reloadData];
         
         
         
     }
     
    
     
    failureBlock:^(NSError *error)
     {
         
     }
     ];
    
    
    

    
}

-(void)viewDidAppear:(BOOL)animated
{
   
//    NSLog(@"View di appear");
//    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
//    [_captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated
{
     [_captureSession stopRunning];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.assetsR.count+1;
}



-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return CGSizeMake(self.collectionData.frame.size.width/6-1,self.collectionData.frame.size.width/6-1);
    }
    else
    {
        return CGSizeMake(self.collectionData.frame.size.width/3-1,self.collectionData.frame.size.width/3-1);
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
        }
        else
        {
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
        }
    }
    else
    {
        ALAsset *asset = self.assetsR[indexPath.row-1];
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                                                       scale:[assetRepresentation scale]
                                                 orientation:UIImageOrientationUp];
        self.image = fullScreenImage;

        [self performSegueWithIdentifier:@"editPhoto" sender:self];
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   
  
    
    if(indexPath.item == 0 && indexPath.item ==0 && indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"cameraCell";
        CustomCollectionViewCell *cameraCell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
       
        
        NSLog(@"Camera cell");
        
        
      
        //[cameraCell.image.layer addSublayer:overlayLayer1];
        
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        session.sessionPreset = AVCaptureSessionPresetHigh;
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        [session addInput:input];
        AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        CGRect bounds=cameraCell.image.bounds;
        newCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        newCaptureVideoPreviewLayer.bounds=bounds;
        newCaptureVideoPreviewLayer.position=CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
        [cameraCell.image.layer addSublayer:newCaptureVideoPreviewLayer];
       // [cameraCell.image.layer insertSublayer:newCaptureVideoPreviewLayer atIndex:0];
        
        
        //cameraCell.image.image = [UIImage imageNamed:@"camera"];
        cameraCell.image.contentMode = UIViewContentModeCenter;
       
      
        UIImage *animationImage = [UIImage imageNamed:@"camera"];
        CALayer *overlayLayer1 = [CALayer layer];
        [overlayLayer1 setContents:(id)[animationImage CGImage]];
        
        overlayLayer1.frame = CGRectMake(25,25, 50.0, 50.0);
        [overlayLayer1 setMasksToBounds:YES];
        [cameraCell.image.layer insertSublayer:overlayLayer1 atIndex:(int)[cameraCell.image.layer.sublayers count]];
        // [cameraCell.image insertSubview:newCaptureVideoPreviewLayer atIndex:2];
        
        [session startRunning];
       
        return cameraCell;
        
    }
    else
    {
        static NSString *CellIdentifier = @"photoCell";
        CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.image.contentMode = UIViewContentModeScaleToFill;
        ALAsset *asset = self.assetsR[indexPath.row-1];
        
        CGImageRef thumbnailImageRef = [asset thumbnail];
        UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
        cell.image.image = thumbnail;
        return cell;
    }
   
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)setupCaptureSession
{
    NSError* error = nil;
    
    // Create the session
    _captureSession = [[AVCaptureSession alloc] init];
    _captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    [_captureSession addInput:input];
    AVCaptureVideoDataOutput* output = [[AVCaptureVideoDataOutput alloc] init];
    [_captureSession addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myCameraOutputQueue", NULL);
    //If you want to sebsequently use the data, then implement the delegate.
    [output setSampleBufferDelegate:self queue:queue];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.cropperImage setOriginalImage:self.image];
    [self performSegueWithIdentifier:@"editPhoto" sender:self];

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"editPhoto"])
    {
        NSLog(@"ijk");
        EditPhotoViewController *data = [segue destinationViewController];
        data.image = self.image;//[self.cropperImage originalImage];
        NSLog(@"%@",self.image);
        data.isTimeline = self.isTimeline;
        
        
//        AdjustPhotoViewController *data = [segue destinationViewController];
//        data.image = self.image;
//        data.isTimeline = self.isTimeline;
    }
}


@end
