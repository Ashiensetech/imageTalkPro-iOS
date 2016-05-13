//
//  LocationViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/30/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationSearchResponse.h"
#import "ApiAccess.h"
//#import "GoogleMaps/GoogleMaps.h"
@import GoogleMaps;
@interface LocationViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ApiAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
    CLLocation *currentLocation;
    
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (strong, nonatomic)  NSMutableArray *myObject;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (strong, nonatomic) IBOutlet UITableView *tableData;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) LocationSearchResponse *responseSearch;
@property (strong,nonatomic) NSString *offset;
@property (assign,nonatomic) BOOL isData;
@property (assign,nonatomic) BOOL loaded;
@property (strong,nonatomic) NSString *keyword;
@property (strong, nonatomic)  NSMutableArray *locations;
@property (strong, nonatomic)  NSMutableArray *selectedLocations;
@end
