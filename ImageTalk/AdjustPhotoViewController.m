//
//  AdjustPhotoViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/26/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "AdjustPhotoViewController.h"
#import "EditPhotoViewController.h"
#import "UIImage+Scale.h"


@interface AdjustPhotoViewController ()

@end

@implementation AdjustPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    self.cropperImage = [[HIPImageCropperView alloc]
                         initWithFrame:self.cropView.bounds
                         cropAreaSize:CGSizeMake(self.view.frame.size.width,self.view.frame.size.width)
                         position:HIPImageCropperViewPositionTop];
    
    self.adjustFitBtn.layer.cornerRadius = 12.0;
    [self.adjustFitBtn.layer setMasksToBounds:YES];
    
    self.adjustFitBtn.frame = CGRectInset(self.adjustFitBtn.frame, -0.5f, -0.5f);
    self.adjustFitBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.adjustFitBtn.layer.borderWidth = 0.5f;
    
    [self.cropView addSubview:self.cropperImage];
    [self.cropperImage setOriginalImage:self.image];
    
    
   

}


- (IBAction)aspectChange:(id)sender {
    
    self.isAspect = !self.isAspect;
    
    if (self.isAspect) {
        [self.cropperImage setOriginalImage:[self.image scaleImageToSize:CGSizeMake(self.image.size.width,self.image.size.width)]];
    }
    else
    {
        [self.cropperImage setOriginalImage:self.image];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"editPhoto"])
    {
        EditPhotoViewController *data = [segue destinationViewController];
        data.image = [self.cropperImage processedImage];
        data.isTimeline = self.isTimeline;
    }
}


@end
