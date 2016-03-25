//
//  ShareLocationViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/2/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "ShareLocationViewController.h"
#import "ToastView.h"
#import "JSONHTTPClient.h"
#import "UIImageView+WebCache.h"
#import "LocationTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TimelineViewController.h"
#import "TagViewController.h"
#import "ApiAccess.h"

@interface ShareLocationViewController ()

@end

@implementation ShareLocationViewController

@synthesize mapView,locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.mapView.myLocationEnabled = NO;
    self.mapView.settings.compassButton = NO;
    self.mapView.settings.zoomGestures = YES;
    self.mapView.settings.myLocationButton = NO;
    self.mapView.accessibilityElementsHidden = NO;
    
    
    GMSMarker *marker=[[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.place.lat, self.place.lng);
    marker.icon = [UIImage imageNamed:@"pin.png"];
    marker.map = self.mapView;
    
    [self.mapView animateToCameraPosition:[GMSCameraPosition
                                           cameraWithLatitude:self.place.lat
                                           longitude:self.place.lng
                                           zoom:14]];
}




#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    NSLog(@"%f %f",newLocation.coordinate.longitude,newLocation.coordinate.latitude);
    [locationManager stopUpdatingLocation];
    
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
   
}


@end
