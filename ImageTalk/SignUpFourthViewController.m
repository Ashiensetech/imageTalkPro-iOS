//
//  SignUpFourthViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "SignUpFourthViewController.h"
#import "JSONHttpClient.h"
#import "ToastView.h"
#import "TimelineViewController.h"

@interface SignUpFourthViewController ()

@end

@implementation SignUpFourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"About You";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
   // [self.keyboardBorder removeFromSuperview];
    
    self.keyboardBorder=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,10)];
    [self.keyboardBorder setBackgroundColor:[UIColor orangeColor]];
    
    self.name.inputAccessoryView = self.keyboardBorder;
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:self.singleTap];
    
    
    self.app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowOrHide:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowOrHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];*/
    
    
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
                  [self.collectionData reloadData];
              }
          }
          ];
     }
     
                    failureBlock:^(NSError *error)
     {
         
     }
     ];


    
    
    
}
- (IBAction)chosePhoto:(id)sender {
    
    self.mainView.hidden = true;
    self.collectionData.hidden = false;
    self.title = @"Chose your photo";
    self.next.hidden = true;
    [self.view removeGestureRecognizer:self.singleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.name resignFirstResponder];
}

-(void)keyboardDidShowOrHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    self.view.frame = newFrame;
    
    [UIView commitAnimations];
}


- (IBAction)complete:(id)sender {
    
    [self.loading startAnimating];
    
    
    self.name.text = [NSString stringWithFormat:@"%@  ",self.name.text];
    NSArray *outputArray = [self.name.text componentsSeparatedByString:@" "];
    NSString *first_name;
    NSString *last_name;
    
    for (int i=0;i<[outputArray count];i++) {
        
        if (i==0)
        {
            first_name = [outputArray objectAtIndex:i];
        }
        else if(i==1)
        {
            last_name = [outputArray objectAtIndex:i];
        }
        else
        {
            last_name = [NSString stringWithFormat:@"%@ %@",last_name,[outputArray objectAtIndex:i]];
        }
        
    }
    
   
    
    NSDictionary *inventory = @{
                                @"phone_number" : self.phone,
                                @"token" : self.token,
                                @"first_name" : first_name,
                                @"last_name" : last_name,
                                @"photo" : [self imageToString:self.pic.image],
                                };
     NSLog(@"%@",inventory);
    
    
    [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@app/register/user",baseurl] params:inventory
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                       
                                       
                                       
                                       NSError* error = nil;
                                       self.response = [[RegistrationResponse alloc] initWithDictionary:json error:&error];
                                       
                                       NSLog(@"%@",error);
                                       
                                       if(error)
                                       {
                                           [ToastView showToastInParentView:self.view withText:@"Server Unreachable" withDuaration:2.0];
                                       }
                                       else
                                       {
                                           [ToastView showToastInParentView:self.view withText:self.response.responseStat.msg withDuaration:2.0 ];
                                       }
                                       
                                       [self.loading stopAnimating];
                                       
                                       if(self.response.responseStat.status){
                                           
                                           NSLog(@"%@",self.response);
                                           [defaults removeObjectForKey:@"access_token"];
                                           [defaults setValue:self.response.responseData.accessToken forKey:@"access_token"];
                                           
                                        
                                           
                                           self.app.authCredential = self.response.responseData;
                                           self.app.userPic = self.response.responseData.user.picPath.original.path;
                                           self.app.wallpost = 0;
                                           self.app.textStatus = self.response.responseData.textStatus;
                                           
                                           
                                           
                                           [[SocektAccess getSharedInstance]setDelegate:self];
                                           [[SocektAccess getSharedInstance]initSocket];
                                           [[SocektAccess getSharedInstance]authentication];
                                    

                                           
                                           
                                           
                                           [self performSegueWithIdentifier:@"next" sender:self];
                                       }
                                       
                                   }];

    
}

#pragma mark - tcpSocketDelegate
-(void)receivedMessage:(NSString *)data
{
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.assets.count+1;
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
        NSLog(@"hgkjhk0");
        ALAsset *asset = self.assets[indexPath.row-1];
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                                                       scale:[assetRepresentation scale]
                                                 orientation:UIImageOrientationUp];
        self.pic.image = fullScreenImage;
        self.collectionData.hidden = true;
        self.title = @"About you";
        self.next.hidden = false;
        self.mainView.hidden = false;
        [self.view addGestureRecognizer:self.singleTap];
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"photoCell";
    
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor darkGrayColor];
    
    
    if(indexPath.row == 0)
    {
        cell.image.image = [UIImage imageNamed:@"camera"];
    }
    else
    {
        ALAsset *asset = self.assets[indexPath.row-1];
        CGImageRef thumbnailImageRef = [asset thumbnail];
        UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
        cell.image.image = thumbnail;
    }
    
    
    return cell;
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
    self.pic.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.collectionData.hidden = true;
    self.title = @"About you";
    self.next.hidden = false;
    self.mainView.hidden = false;
    [self.view addGestureRecognizer:self.singleTap];
    
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
    
    return [imageData base64Encoding];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"next"])
    {
       // TimelineViewController *data= segue.destinationViewController;
       
    }
}


@end
