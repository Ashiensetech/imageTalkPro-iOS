//
//  ShareLocationViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/2/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Places.h"
#import "ApiAccess.h"
#import "TimelineResponse.h"
#import "LikeResponse.h"
#import "FavResponse.h"
@import MapKit;
@interface ShareLocationViewController : UIViewController<CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ApiAccessDelegate>
{
    CLLocation *currentLocation;
    NSUserDefaults *defaults;
    NSString *baseurl;
}


@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
//@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) UIImageView *image;
@property (strong, nonatomic) Places *place;
@property (strong, nonatomic) IBOutlet MKMapView *appleMapView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) TimelineResponse *data;
@property (strong,nonatomic) LikeResponse *dataLike;
@property (strong,nonatomic) FavResponse *dataFav;
@property (strong,nonatomic) WallPost *post;
@property (strong,nonatomic) NSMutableArray *myObject;

@end
