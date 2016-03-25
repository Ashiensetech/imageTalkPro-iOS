//
//  ShopDetailsViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/17/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailsViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *money;
@property (strong, nonatomic) IBOutlet UIButton *invite;
@property (strong, nonatomic) IBOutlet UIButton *buy;
@property (strong, nonatomic) IBOutlet UILabel *details;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionData;


@property (strong, nonatomic) NSString *name_;
@property (strong, nonatomic) UIImage *image_;
@property (strong, nonatomic)  NSArray *myObject;
@end
