//
//  ApiAccess.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/2/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccessTokenResponse.h"
#import "Response.h"
#import "SocektAccess.h"
#import "AppDelegate.h"
@import MapKit;
@protocol ApiAccessDelegate <NSObject>

@required
-(void)receivedResponse:(NSDictionary*)data tag:(NSString*) tag index:(int) index;
-(void)receivedError:(JSONModelError*)error tag:(NSString*) tag;
@end


@interface ApiAccess : NSObject
{
    NSUserDefaults *defaults;
    NSString *baseurl;
    NSString *accessToken;
}


@property (nonatomic,assign) id<ApiAccessDelegate> delegate;
@property (strong, nonatomic) AccessTokenResponse *response;

+(ApiAccess*)getSharedInstance;

- (void) initUrls;
- (void) loginAccess;
- (void) postRequestWithUrl:(NSString*) url params:(NSDictionary*) params tag:(NSString*) tag;
- (void) postRequestWithUrl:(NSString*) url params:(NSDictionary*) params tag:(NSString*) tag index:(int) index;
- (void) getRequestWithUrl:(NSString*) url params:(NSDictionary*) params tag:(NSString*) tag;
- (void) getRequestForGoogleWithParams:(NSDictionary*) params tag:(NSString*) tag;
-(void) mapKitServiceWithCLLocationCoordinate2D:(CLLocationCoordinate2D)start Keyboard :(NSString *) keyboard andTag : (NSString *) tag;


@end
