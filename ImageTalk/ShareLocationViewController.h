//
//  ShareLocationViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/2/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Places.h"

#import "GoogleMaps/GoogleMaps.h"


@interface ShareLocationViewController : UIViewController<CLLocationManagerDelegate>
{
    CLLocation *currentLocation;
}


@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) UIImageView *image;
@property (strong, nonatomic) Places *place;


@end
