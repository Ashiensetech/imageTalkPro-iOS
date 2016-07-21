//
//  PrivatePhotoViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 12/2/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "PrivatePhotoViewController.h"
#import "ChatViewController.h"

CGFloat const kMinZoomScaleI = 0.5f;
CGFloat const kMaxZoomScaleI = 2.2f;
CGFloat const kInitialZoomScaleI = 0.5f;

@interface PrivatePhotoViewController ()

@end

@implementation PrivatePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  self.cropperImage = [[HIPImageCropperView alloc]
  //                       initWithFrame:self.imageView.bounds
  //                       cropAreaSize:CGSizeMake(self.view.frame.size.width,self.view.frame.size.height)
  //                       position:HIPImageCropperViewPositionCenter];
    
  
 //   [self.cropperImage setClipsToBounds:NO];
    
  //  [self.imageView addSubview:self.cropperImage];
  //  [self.cropperImage setOriginalImage:self.image];
    
    self.body.image = self.image;
    self.body.frame = self.scrollView.frame;
    [self.body setContentMode:UIViewContentModeScaleAspectFit];
    [self.scrollView addSubview:self.body];
    [self.body setUserInteractionEnabled:YES];
    [self calculateScrollViewScale];
    self.scrollView.zoomScale = self.initialZoomLevel;
    [self centerScrollViewContents];
    self.scrollView.delegate = self;
    self.popUp.hidden = YES;
    self.popUpImage.hidden = YES;
}

#pragma mark - Scroll View Delegate

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.body.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.body.frame = contentsFrame;
}

#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.body;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    [self centerScrollViewContents];
}

#pragma mark - Rotation handling

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    // Don't do this if the imageview doesnt exist yet.
    if(self.body == nil){
        return;
    }
    [UIView animateWithDuration:duration animations:^{
        self.body.alpha = 0;
        [self centerScrollViewContents];
    }];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    // Don't do this if the imageview doesnt exist yet.
    if(self.body == nil){
        return;
    }
    // Seems we have to tear down and recreate the image view or this wont work.
    [self.body removeFromSuperview];
    UIImage *oldImage = self.body.image;
    self.body = nil;
    self.body = [[UIImageView alloc] initWithImage:oldImage];
    self.body.frame = self.scrollView.frame;
    [self.body setContentMode:UIViewContentModeScaleAspectFit];
    [self.scrollView addSubview:self.body];
    [self.body setUserInteractionEnabled:YES];
    [self calculateScrollViewScale];
    self.scrollView.zoomScale = self.initialZoomLevel;
    [self centerScrollViewContents];
    [UIView animateWithDuration:.5 animations:^{
        self.body.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)calculateScrollViewScale{
    [self.scrollView setContentSize:self.body.frame.size];
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MAX(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = kMaxZoomScaleI;
    self.initialZoomLevel=minScale;
}


//
//- (IBAction)noTimer:(id)sender {
//    self.timerLabel.text = @"No Timer";
//    self.timer = 0;
//    self.popUp.hidden = YES;
//    self.popUpImage.hidden = YES;
//    
//}
//- (IBAction)tenS:(id)sender {
//    self.timerLabel.text = @"10 Seconds";
//    self.timer = 10;
//    self.popUp.hidden = YES;
//    self.popUpImage.hidden = YES;
//    
//}
- (IBAction)thirtyS:(id)sender {
    self.timerLabel.text = @"No Timer";
    self.timer = 0;
    self.popUp.hidden = YES;
    self.popUpImage.hidden = YES;
    
}
- (IBAction)oneM:(id)sender {
     self.timerLabel.text = @"15 Seconds";
    self.timer = 15;
    self.popUp.hidden = YES;
    self.popUpImage.hidden = YES;
}
- (IBAction)twoM:(id)sender {
    self.timerLabel.text = @"10 Seconds";
    self.timer = 10;
    self.popUp.hidden = YES;
    self.popUpImage.hidden = YES;
}
- (IBAction)fiveM:(id)sender {
    self.timerLabel.text = @"5 Seconds";
    self.timer = 5;
    self.popUp.hidden = YES;
    self.popUpImage.hidden = YES;
}


- (IBAction)send:(id)sender {
    
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    ChatViewController *data1 = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
    data1.isPrivate = true;
    data1.timer = self.timer;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)showHidePop:(id)sender {
    
    self.popUp.hidden = !self.popUp.hidden;
    self.popUpImage.hidden = !self.popUpImage.hidden;
    
}

- (IBAction)close:(id)sender {
    
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    ChatViewController *data1 = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
    data1.isPrivate = false;
    [self.navigationController popViewControllerAnimated:NO];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

-(void) viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
