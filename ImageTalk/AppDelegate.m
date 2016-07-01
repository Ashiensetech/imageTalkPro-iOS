//
//  AppDelegate.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "AppDelegate.h"
#import "JSONHTTPClient.h"
#import "ToastView.h"
#import "SocektAccess.h"
#import "SoundManager.h"
#import "SocketResponse.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "VKSdk.h"
#import "NotificationViewController.h"

//#import <GoogleMaps/GoogleMaps.h>
@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    
   //This code will work in iOS 8.0 xcode 6.0 or later
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }


    
    [SoundManager sharedManager].allowsBackgroundMusic = YES;
    [[SoundManager sharedManager] prepareToPlay];
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        
        application.applicationIconBadgeNumber = 0;
    }
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
                                                                                                              categories:nil]];
    }

    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:238.00/255.00 green:117.00/255.00 blue:13.00/255.00 alpha:1]];
    [[UITabBar appearance] setTranslucent:NO];
    
    
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:238.00/255.00 green:117.00/255.00 blue:13.00/255.00 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSShadowAttributeName: shadow,
                                                           NSFontAttributeName: [UIFont fontWithName:@"Arcitectura" size:26.0f]
                                                           }];
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil]
     forState:UIControlStateNormal];
    
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [GMSServices provideAPIKey:@"AIzaSyAsgxFpn_lHDqw3oj81fguR4Q6BFBk-pPs"];
    
  //  [defaults setValue:@"http://159.203.253.167:8080/" forKey:@"baseurl"];
  //  [defaults setValue:@"159.203.253.167" forKey:@"socketurl"];
  //  [defaults setValue:@"9025" forKey:@"port"];
    
     [defaults setValue:@"http://163.53.151.2:9020/" forKey:@"baseurl"];
     [defaults setValue:@"163.53.151.2" forKey:@"socketurl"];
     [defaults setValue:@"9025" forKey:@"port"];
    

    [defaults setValue:@"1ab4fb622d9e6f5dfdff193c38a1c93d17a38e91" forKey:@"gmskey"];
    
    
 
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.contacts = [[NSMutableArray alloc]init];
    
    
    self.timers = [[NSMutableDictionary alloc]init];
    


    
    NSLog(@"%@",[defaults objectForKey:@"access_token"]);
    
    if([defaults objectForKey:@"access_token"])
    {
        
       // NSLog(@"%@app/login/authenticate/accesstoken?%@",[defaults objectForKey:@"baseurl"],[NSString stringWithFormat:@"access_token=%@",[defaults objectForKey:@"access_token"]]);
        
        [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@app/login/authenticate/accesstoken",[defaults objectForKey:@"baseurl"]] bodyString:[NSString stringWithFormat:@"access_token=%@",[defaults objectForKey:@"access_token"]]
                                       completion:^(NSDictionary *json, JSONModelError *err) {
                                           
                                           
                                           
                                           NSError* error = nil;
                                           self.response = [[AccessTokenResponse alloc] initWithDictionary:json error:&error];
                                           
                                           
                                           if(error)
                                           {
                                               [ToastView showToastInParentView:self.window withText:@"Server Unreachable" withDuaration:2.0];
                                           }
                                           
                                           
                                           if(self.response.responseStat.status){
                                               
    
                                               
                                               if (self.response.responseData.contacts.count > 0)
                                               {
                                                   
                                                   for(int i=0;i<self.response.responseData.contacts.count;i++)
                                                   {
                                                       [self.contacts addObject:self.response.responseData.contacts[i]];
                                                   }
                                               }
                                              
                                               
                                               NSDictionary *userDic = @{@"userId" : self.response.responseData.authCredential.user.id ,
                                                   @"deviceId" :self.response.responseData.authCredential.user.deviceId};
                                               
                                               
                                               [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"appUser"];
                                               
                                               self.authCredential = self.response.responseData.authCredential;
                                               self.userPic = self.response.responseData.authCredential.user.picPath.original.path;
                                               self.wallpost = self.response.responseData.extra.wallPost;
                                               self.textStatus = self.response.responseData.authCredential.textStatus;
                                               self.userId=self.response.responseData.authCredential.user.id;
                                              
                                               
                                               UITabBarController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"timeline"];
                                               

                                               [[SocektAccess getSharedInstance]setDelegate:self];
                                               [[SocektAccess getSharedInstance]initSocket];
                                               [[SocektAccess getSharedInstance]authentication];
                                               [[SocektAccess getSharedInstance]setItem:[rootViewController.tabBar.items objectAtIndex:1]];
                                               
                                               
                                               
                                               
                                               self.window.rootViewController = rootViewController;
                                               [self.window makeKeyAndVisible];
                                               
                                               
                                               

                                           }
                                           else
                                           {
                                               UITabBarController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"timeline"];
                                               [[SocektAccess getSharedInstance]setItem:[viewController.tabBar.items objectAtIndex:1]];
                                               self.window.rootViewController = viewController;
                                               [self.window makeKeyAndVisible];
                                           }
                                           
                                       }];

       
        
    }
    else
    {
        UITabBarController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"timeline"];
        [[SocektAccess getSharedInstance]setItem:[rootViewController.tabBar.items objectAtIndex:1]];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"registration"];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
       
    }

    
  
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive) {
        
        
        
    }
    [[SoundManager sharedManager] playSound:@"sound2" looping:NO];
    NSLog(@"REceived local");

}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"deviceToken"];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification");
    NSLog(@"app state :%ld", (long)application.applicationState);
    if( application.applicationState == UIApplicationStateBackground || application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateActive )
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"timeline"];
        
        [rootViewController setSelectedIndex:3];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    }else{
        
    
    
    }
}
#pragma mark - tcpSocketDelegate
-(void)receivedMessage:(NSString *)data
{
    
    NSError* err = nil;
    SocketResponse *response = [[SocketResponse alloc] initWithString:data error:&err];
    NSLog(@"ASD %@",response);
    
    
    
   if([response.responseStat.tag isEqualToString:@"textchat"] || [response.responseStat.tag isEqualToString:@"chatphoto_transfer"] || [response.responseStat.tag isEqualToString:@"chatprivatephoto_transfer"] || [response.responseStat.tag isEqualToString:@"chatlocation_share"] || [response.responseStat.tag isEqualToString:@"chatcontact_share"])
    {
        [SocektAccess getSharedInstance].badgeValue++;
        [[SocektAccess getSharedInstance]setBadge];
    }
   
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                                  openURL:url
//                                                        sourceApplication:sourceApplication
//                                                               annotation:annotation
//                    ];
//
//      [VKSdk processOpenURL:url fromApplication:sourceApplication];
    // Add any custom logic here.
//    return handled;
    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    return YES;
}




@end
