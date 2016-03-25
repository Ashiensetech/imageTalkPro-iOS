//
//  ShopDetailsViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/17/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "ShopDetailsViewController.h"
#import "CustomCollectionViewCell.h"
#import "Sticker.h"
#import "UIImageView+WebCache.h"

@interface ShopDetailsViewController ()

@end

@implementation ShopDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    self.image.image = self.image_;
    self.name.text = self.name_;
    
    self.invite.layer.cornerRadius = 3;
    [self.invite.layer setMasksToBounds:YES];
    
    self.buy.layer.cornerRadius = 3;
    [self.buy.layer setMasksToBounds:YES];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.myObject.count;
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


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"photoCell";
    
    NSLog(@"ihdifgs");
    
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    
    cell.image.contentMode = UIViewContentModeCenter;
    Sticker *data = self.myObject[indexPath.row];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/sticker?p=%@",baseurl,data.path]]
                  placeholderImage:nil];
    
    NSLog(@"%@",[NSMutableString stringWithFormat:@"%@app/media/access/sticker?p=%@",baseurl,data.path]);
    
    
    return cell;
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
