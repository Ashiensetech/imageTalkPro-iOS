//
//  LocationViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/30/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "LocationViewController.h"
#import "JSONHTTPClient.h"
#import "LocationTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SharePhotoViewController.h"
#import "ChatViewController.h"
#import "ToastView.h"

#import "ApiAccess.h"
#import "MapLocation.h"
@import MapKit;
@interface LocationViewController ()
{
    CLLocationCoordinate2D start;
}
@end

@implementation LocationViewController

@synthesize locationManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    
    //  self.myObject = [[NSMutableArray alloc] init];
    
    self.offset = @"";
    self.loaded = false;
    self.keyword = @"";
    
    self.locations = [[NSMutableArray alloc]init];
    self.selectedLocations = [[NSMutableArray alloc]init];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
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
    start.latitude =newLocation.coordinate.latitude;
    start.longitude = newLocation.coordinate.longitude;
    
    [locationManager stopUpdatingLocation];
    
    [self getData:self.keyword];
    
    
}

-(void) getData:(NSString*) keyboard{
    
    [self.loading startAnimating];
    
    NSLog(@"manager location :%@",self.locationManager.location);
    
    
    
    [[ApiAccess getSharedInstance] mapKitServiceWithCLLocationCoordinate2D :start  Keyboard:keyboard andTag : @"getLocationData"];
    
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if(y > h + reload_distance) {
        
        
        if(self.isData && self.loaded)
        {
            
            self.loaded = false;
            [self getData:self.keyword];
            
            NSLog(@"load more rows");
        }
        
        
    }
    
}

#pragma mark - table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"numberOfRowsInSection: %d",self.locations.count);
    
    return self.locations.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    MKMapItem * data = self.locations[indexPath.row];
    
    cell.address.text =[NSString stringWithFormat:@"%@",data.name];
    cell.duration.text = [NSString stringWithFormat:@"%@",[[data.placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@"," ]];
    cell.image.image = [UIImage imageNamed:@"loc"];
    
    return cell;
    
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       // Places *data =self.myObject[indexPath.row];
    
    MKMapItem *data  = self.locations[indexPath.row];
        NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
        if([[self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2] isKindOfClass:[SharePhotoViewController class]])
        {
            SharePhotoViewController *data1 = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
            //data1.place = data;
            data1.postLocation = data;
        }
        else
        {
            ChatViewController *data1 = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
          //  data1.placeToSend = data;
        }
    
        [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    self.locations =[[NSMutableArray alloc] init];
    //self.myObject = [[NSMutableArray alloc] init];
    self.loaded = false;
    self.offset = @"";
    NSLog(@"%@",searchBar.text);
    [self getData:searchBar.text];
    [self.view endEditing:YES];
    
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    [self.tableData reloadData];
    
    return YES;
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.keyword = searchText;
    [self getData:self.keyword];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    // NSLog(@"%@",tag);
    [self.loading stopAnimating];
    
    if ([tag isEqualToString:@"getLocationData"])
    {
        
        NSError* error = nil;
        // NSLog(@"%@",data);
        //        self.responseSearch = [[LocationSearchResponse alloc] initWithDictionary:data error:&error];
        //
        //
        //     //   NSLog(@"%@ %@",error,self.responseSearch);
        //
        //            self.offset = [NSString stringWithFormat:@"%@",self.responseSearch.next_page_token];
        //            self.isData = !self.offset;
        //
        //            if(self.responseSearch.results.count>0)
        //            {
        //
        //                for(int i=0;i<self.responseSearch.results.count;i++)
        //                {
        //                    GooglePlaces *pl = self.responseSearch.results[i];
        //                    Places *send = [[Places alloc]init];
        //                    send.placeId = pl.placeId;
        //                    send.lat = pl.lat;
        //                    send.lng = pl.lng;
        //                    send.name = pl.name;
        //                    send.formattedAddress = pl.formattedAddress;
        //                    send.rating = pl.rating;
        //                    send.icon = pl.icon;
        //                    send.id = pl.id;
        //
        //                    [self.myObject addObject:send];
        //                }
        //            }
        //            else
        //            {
        //                self.isData = false;
        //            }
        //
        //            self.loaded = true;
        
        
        NSMutableArray *result = [data valueForKey:@"response"];
        if(result.count>0){
            for (MKMapItem *item in result) {
                [self.locations addObject:item];
            }
        }
        
        
        [self.tableData reloadData];
    }
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    NSLog(@"eroor:%@",error);
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    [self.loading stopAnimating];
    
    if ([tag isEqualToString:@"getLocationData"])
    {
        [self.tableData reloadData];
    }
    
    
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
