//
//  ApiAccess.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/2/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "ApiAccess.h"
#import "JSONHTTPClient.h"
#import "MYHTTPRequestOperationManager.h"
@import MapKit;
static ApiAccess *sharedInstance = nil;

@implementation ApiAccess

+(ApiAccess*)getSharedInstance{
    
    if (!sharedInstance) {
     
       [sharedInstance initUrls];
       sharedInstance = [[super allocWithZone:NULL]init];
        
    }
    
    return sharedInstance;
}

- (void) initUrls{
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    accessToken = [defaults objectForKey:@"access_token"];
}

- (void) postRequestWithUrl:(NSString*) url params:(NSDictionary*) params tag:(NSString*) tag
{
    [self postRequestWithUrl:url params:params tag:tag index:0];
}



- (void) postRequestWithUrl:(NSString*) url params:(NSDictionary*) params tag:(NSString*) tag index:(int) index
{
  
    [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseurl"],url] params:params
                                   completion:^(NSDictionary *json, JSONModelError *err)
     {
         
       //  NSLog(@"%@",params);
        
         if(err)
         {
             NSLog(@"HGFHGF %@",err);
             [self.delegate receivedError:err tag:tag];
         }
         else
         {
             NSError* error = nil;
             Response *response = [[Response alloc] initWithDictionary:json error:&error];
             
             NSLog(@"%@",response);
             
             if (response.responseStat.isLogin) {
                 [self.delegate receivedResponse:json tag:tag index:index];
             }
             else
             {
                 [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@app/login/authenticate/accesstoken",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseurl"]] bodyString:[NSString stringWithFormat:@"access_token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]
                                                completion:^(NSDictionary *json, JSONModelError *err)
                  {
                      
                      NSError* error = nil;
                      AccessTokenResponse *response = [[AccessTokenResponse alloc] initWithDictionary:json error:&error];
                    
                      if(response.responseStat.status)
                      {
                          NSLog(@"LOgin");
                          
                          AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                          app.authCredential = response.responseData.authCredential;
                          app.userPic = response.responseData.authCredential.user.picPath.original.path;
                          app.wallpost = response.responseData.extra.wallPost;
                          app.textStatus = response.responseData.authCredential.textStatus;
                          
                          [[SocektAccess getSharedInstance]initSocket];
                          [[SocektAccess getSharedInstance]authentication];
                        
                          
                          [self postRequestWithUrl:url params:params tag:tag index:index];
                      }
                     
                  }];

             }
             
             
            
         }
         
         
         
     }];
    
}

- (void) getRequestWithUrl:(NSString*) url params:(NSDictionary*) params tag:(NSString*) tag
{
     MYHTTPRequestOperationManager *manager = [MYHTTPRequestOperationManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager GET:[NSString stringWithFormat:@"%@%@",baseurl,url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSError* error = nil;
        Response *response = [[Response alloc] initWithDictionary:responseObject error:&error];
        
        if (response.responseStat.isLogin) {
            [self.delegate receivedResponse:responseObject tag:tag index:0];
        }
        else
        {
            [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@app/login/authenticate/accesstoken",baseurl] bodyString:[NSString stringWithFormat:@"access_token=%@",accessToken]
                                           completion:^(NSDictionary *json, JSONModelError *err)
             {
                 
                 NSError* error = nil;
                 AccessTokenResponse *response = [[AccessTokenResponse alloc] initWithDictionary:json error:&error];
                 
                 if(response.responseStat.status)
                 {
                     [self postRequestWithUrl:url params:params tag:tag];
                 }
                 
             }];
            
        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        //[self.delegate receivedError:error tag:tag];
    }];
    
    
//    [JSONHTTPClient getJSONFromURLWithString:[NSString stringWithFormat:@"%@%@",baseurl,url] params:params completion:^(id json, JSONModelError *err)
//    {
//      
//         if(err)
//         {
//             [self.delegate receivedError:err tag:tag];
//         }
//         else
//         {
//             NSError* error = nil;
//             Response *response = [[Response alloc] initWithDictionary:json error:&error];
//             
//             if (response.responseStat.isLogin) {
//                 [self.delegate receivedResponse:json tag:tag index:0];
//             }
//             else
//             {
//                 [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@app/login/authenticate/accesstoken",baseurl] bodyString:[NSString stringWithFormat:@"access_token=%@",accessToken]
//                                                completion:^(NSDictionary *json, JSONModelError *err)
//                  {
//                      
//                      NSError* error = nil;
//                      AccessTokenResponse *response = [[AccessTokenResponse alloc] initWithDictionary:json error:&error];
//                      
//                      if(response.responseStat.status)
//                      {
//                          [self postRequestWithUrl:url params:params tag:tag];
//                      }
//                      
//                  }];
//                 
//             }
//             
//             
//             
//         }
//
//        
//     }];
    
}

- (void) getRequestForGoogleWithParams:(NSDictionary*) params tag:(NSString*) tag
{
   
    NSLog(@"%@",params);
    
    NSDictionary * newParam = @{@"key":@"29362df98623085a9b086b0979fa79c00ac0ee62" ,@"location" : [params valueForKey:@"location"],@"name":[params valueForKey:@"name"],@"pagetoken":[params valueForKey:@"pagetoken"],@"radius":[params valueForKey:@"radius"],@"sensor":@false};
    
    [JSONHTTPClient getJSONFromURLWithString:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json" params:newParam completion:^(id json, JSONModelError *err)
     {
         
         if(err)
         {
             [self.delegate receivedError:err tag:tag];
         }
         else
         {
    
             NSLog(@"%@",json);
            [self.delegate receivedResponse:json tag:tag index:0];
         }
         
         
     }];

}




- (void) loginAccess
{
    [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@app/login/authenticate/accesstoken",baseurl] bodyString:[NSString stringWithFormat:@"access_token=%@",accessToken]
                                   completion:^(NSDictionary *json, JSONModelError *err)
     {
         
         NSError* error = nil;
         AccessTokenResponse *response = [[AccessTokenResponse alloc] initWithDictionary:json error:&error];
         
         NSLog(@"%@",error);
         
         if(error)
         {
             
         }
         else
         {
             
             if(response.responseStat.status)
             {
                 
             }
             else
             {
                 
             }
         }
         
         
         
     }];
}


-(void) mapKitServiceWithCLLocationCoordinate2D:(CLLocationCoordinate2D)start Keyboard :(NSString *) keyboard andTag : (NSString *) tag{
    MKCoordinateSpan span;
    span.latitudeDelta = 0.002;
    span.longitudeDelta = 0.002;
    MKCoordinateRegion region;
    region.span = span;
    region.center = start;
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = keyboard;
    request.region = region;
    // Create and initialize a search object.
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    // Start the search and display the results as annotations on the map.
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         if(error)
         {
             
             [self.delegate receivedError:@{@"error": @"No Location found"} tag:tag];
         }
         else
         {
             
            // NSLog(@"%@",json);
             [self.delegate receivedResponse:@{@"response": response.mapItems} tag:tag index:0];
         }
     }];
}

@end
