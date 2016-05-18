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
#import "CustomCollectionViewCell.h"
@interface ShareLocationViewController ()

@end

@implementation ShareLocationViewController

//@synthesize mapView,locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    

    
    
    CLLocationCoordinate2D noLocation;
    noLocation.latitude = self.place.lat;
    noLocation.longitude = self.place.lng;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 750, 750);
    MKCoordinateRegion adjustedRegion = [self.appleMapView regionThatFits:viewRegion];
    [self.appleMapView setRegion:adjustedRegion animated:YES];
    self.appleMapView.showsUserLocation = NO;
    CLLocation *locObj = [[CLLocation alloc] initWithLatitude:self.place.lat longitude:self.place.lng];
    CLGeocoder *geoCoder2 = [[CLGeocoder alloc] init];
    [geoCoder2 reverseGeocodeLocation:locObj completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error){
            //do something
        }
        if(placemarks && placemarks.count){
            CLPlacemark *placemark2 = placemarks[0];
            
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:placemark2];
            
            [self.appleMapView addAnnotation:placemark];
        }
    }];
    [self.collectionView setDelegate:self];
    
    self.myObject = [[NSMutableArray alloc]init];

    
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    
    [self getData];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [[ApiAccess getSharedInstance] setDelegate:self];
}

-(void) getData{
//    NSDictionary *inventory = @{@"offset" : [NSString stringWithFormat:@"%d",2]};
//    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/stickers/get/for/post" params:inventory tag:@"getNearbyPost"];
    
    NSDictionary *inventory = @{@"lat" : [NSString stringWithFormat:@"%f",self.place.lat],
                                @"lng" : [NSString stringWithFormat:@"%f",self.place.lng]
                                };
    [[ApiAccess getSharedInstance]postRequestWithUrl:@"app/wallpost/get/nearby" params:inventory tag:@"getNearbyPost"];


}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
   // return self.myObject.count;
    return 5;
}



-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return CGSizeMake(self.collectionView.frame.size.width/6-1,self.collectionView.frame.size.width/6-1);
    }
    else
    {
        return CGSizeMake(self.collectionView.frame.size.width/3-1,self.collectionView.frame.size.width/3-1);
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    Wallpost *data = self.myObject[indexPath.row];
//    [self.imageSticker sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/sticker?p=%@",baseurl,data.path]]
//                         placeholderImage:nil];
//    
//    [self performSegueWithIdentifier:@"tag" sender:self];
    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"photoCell";
    
    NSLog(@"ihdifgs");
    
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    
    cell.image.contentMode = UIViewContentModeCenter;
    cell.image.image = [UIImage imageNamed:@"angryL.png"];
//    WallPost *data = self.myObject[indexPath.row];
//    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/sticker?p=%@",baseurl,data.picPath]]
//                  placeholderImage:nil];
//    
//    NSLog(@"%@",[NSMutableString stringWithFormat:@"%@app/media/access/sticker?p=%@",baseurl,data.picPath]);
    
    
    return cell;
}


#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    
    
    if ([tag isEqualToString:@"getNearbyPost"])
    {
    
        
        
        NSError* error = nil;
              self.data = [[TimelineResponse alloc] initWithDictionary:data error:&error];
        NSLog(@" self data%@",self.data);
        if(self.data.responseStat.status)
        {
             NSLog(@" objects: %@",self.data.responseData);
            for(int i=0;i<self.data.responseData.count;i++)
            {
               
                [self.myObject addObject:self.data.responseData[i]];
                
            }
            
       
        }
        
    }
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    NSLog(@"Received error");
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
    if ([tag isEqualToString:@"getNearbyPost"])
    {
        [self.collectionView reloadData];
    }
    
    
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
   
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
    [self.locationManager stopUpdatingLocation];
    
    
}

@end
