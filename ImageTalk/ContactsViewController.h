//
//  ContactsViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ContactsData.h"
#import "UIImageView+WebCache.h"
#import "ContactsResponse.h"
#import "ContactResponse.h"
#import "Response.h"
#import "AppDelegate.h"
#import "ApiAccess.h"

@interface ContactsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ApiAccessDelegate>
{
    //NSDictionary *contacts;
    //NSArray *contactsSectionTitles;
    NSUserDefaults *defaults;
    NSString *baseurl;

}


@property (strong, nonatomic)  NSMutableArray *myObject;
@property (strong, nonatomic)  AppDelegate *app;
@property (strong, nonatomic)  NSMutableArray *contactsList;
@property (strong, nonatomic)  NSMutableDictionary *contactsData;
@property (strong, nonatomic)  NSArray *contactsTitles;
@property (strong, nonatomic)  NSMutableArray *contactStringArray;
@property (strong, nonatomic)  NSString *contactString;
@property (strong, nonatomic)  NSString *contactAddString;
@property (strong, nonatomic)  ContactResponse *responseC;
@property (strong, nonatomic)  ContactsResponse *response;
@property (strong, nonatomic)  Response *responseAdd;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableData;
@property (strong, nonatomic) IBOutlet UITableView *tableMainData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainHeight;
@property (strong, nonatomic) NSString *keyword;
@property (assign,nonatomic) int offset;
@property (assign,nonatomic) int contactCount;
@property (assign,nonatomic) BOOL isData;
@property (assign,nonatomic) BOOL loaded;

@end
