//
//  SelectContactViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/6/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactResponse.h"
#import "ApiAccess.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface SelectContactViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,ApiAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}

@property (strong, nonatomic) NSString *keyword;
@property (assign,nonatomic) int offset;
@property (assign,nonatomic) BOOL isData;
@property (assign,nonatomic) BOOL loaded;

@property (strong, nonatomic) NSMutableArray *contactsList;
@property (strong, nonatomic) NSMutableArray *myObject;
@property (strong, nonatomic) ContactResponse *response;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableData;

@end
