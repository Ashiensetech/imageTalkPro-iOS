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
    
     self.selectedLocations = [[NSMutableArray alloc]init];

    
    [self getData:@""];
    [self.view endEditing:YES];
   
    
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
    if(self.locations ==NULL){
     self.locations =[[NSMutableArray alloc] init];
    }
    
    start.latitude =currentLocation.coordinate.latitude;
    start.longitude = currentLocation.coordinate.longitude;
    [[ApiAccess getSharedInstance] FBLocationWithCenter:start Keyboard:(NSString *)keyboard andTag:@"getFBLocation" andOffset: self.offset];
    
    
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
    
    
    
    
    Places *data = self.locations[indexPath.row];
    cell.address.text = [NSString stringWithFormat:@"%@",data.name];
    cell.duration.text = [NSString stringWithFormat:@"%@",data.formattedAddress];
    cell.image.image = [UIImage imageNamed:@"loc"];
    
    return cell;
    
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       // Places *data =self.myObject[indexPath.row];
    
    Places *data  = self.locations[indexPath.row];
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
           data1.placeToSend = data;
        }
    
        [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
   
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
    self.locations =[[NSMutableArray alloc] init];
    //self.myObject = [[NSMutableArray alloc] init];
    self.loaded = false;
    self.offset = @"";
    NSLog(@"%@",searchBar.text);
    [self getData:searchBar.text];
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
        NSMutableArray *result = [data valueForKey:@"response"];
        NSLog(@"%@",result);
        if(result.count>0){
            for (MKMapItem *item in result) {
                [self.locations addObject:item];
            }
        }
        
        
        [self.tableData reloadData];
    }
    if([tag isEqualToString:@"getFBLocation"]){
        
        NSMutableArray *result = [data valueForKey:@"data"];
        NSDictionary  *paging  = [data valueForKey:@"paging"];
        
        NSLog(@"page :%@",paging);
        if(result.count>0){
            _isData = true;
            for (int i=0; i<result.count;i++ ) {
                
                NSLog(@"we are here");
                NSObject *pl = result[i];
                 NSLog(@"we are here 1");
                Places *send = [[Places alloc]init];
                send.placeId = [pl valueForKey:@"id"];
                send.lat = [[[pl valueForKey:@"location"]valueForKey:@"latitude"]floatValue];
                send.lng = [[[pl valueForKey:@"location"]valueForKey:@"longitude"]floatValue];
                send.name = [pl valueForKey:@"name"];
                send.formattedAddress = [NSString stringWithFormat:@"%@,%@,%@,%@",[pl valueForKey:@"category"],[[pl valueForKey:@"location"]valueForKey:@"street"],[[pl valueForKey:@"location"]valueForKey:@"city"],[[pl valueForKey:@"location"]valueForKey:@"country"]];
                send.rating =0.0;
                send.icon = @"";
              //  send.id = pl.id;
                [self.locations addObject:send];
            }
        }

       
        else
        {
            self.isData = false;
        }
        if(paging !=NULL){
            self.offset = [paging valueForKey:@"next"];
        }
        
        self.loaded = true;
        [self.tableData reloadData];
        
    }
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    NSLog(@"eroor:%@",error);
    [ToastView showErrorToastInParentView:self.view withText:@"No Nearby Location Found" withDuaration:2.0];
    [self.loading stopAnimating];
    
    if ([tag isEqualToString:@"getLocationData"])
    {
        [self.tableData reloadData];
    }
    if ([tag isEqualToString:@"getFBLocation"])
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
