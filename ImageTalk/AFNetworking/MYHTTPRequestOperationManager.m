//
//  MYHTTPSessionManager.m
//  ImageTalk
//
//  Created by Workspace Infotech on 5/7/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import "MYHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperationManager.h"

@implementation MYHTTPRequestOperationManager


- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *modifiedRequest = request.mutableCopy;
    
    AFNetworkReachabilityManager *reachability = self.reachabilityManager;
    if (!reachability.isReachable)
    {
        modifiedRequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    
    AFHTTPRequestOperation *operation = [super HTTPRequestOperationWithRequest:modifiedRequest
                                                                       success:success
                                                                       failure:failure];
    
    [operation setCacheResponseBlock: ^NSCachedURLResponse *(NSURLConnection *connection,
                                                             NSCachedURLResponse *cachedResponse)
     {
         // Modify cache header as shown above
         
         NSLog(@"called");
         return 0;
     }];
    
    return operation;
}



@end
