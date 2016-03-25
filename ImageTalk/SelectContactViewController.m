//
//  SelectContactViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/6/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "SelectContactViewController.h"
#import "ContactsTableViewCell.h"
#import "JSONHTTPClient.h"
#import "ToastView.h"
#import "ApiAccess.h"
#import "ChatViewController.h"
#import "UIImageView+WebCache.h"

@interface SelectContactViewController ()

@end

@implementation SelectContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"Select Contact"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden= YES;
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    self.myObject = [[NSMutableArray alloc] init];
    
    self.offset = 0;
    self.loaded = false;
    self.keyword = @"";
    [self getData:self.offset keyword:self.keyword];
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion((__bridge ABAddressBookRef)(self), ^(bool granted, CFErrorRef error) {
            if (granted) {
                self.contactsList=[self getAllContacts];
            } else {
                
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        self.contactsList=[self getAllContacts];
           }
    else {
    }

}

- (NSMutableArray *)getAllContacts {
    
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allPeople = (ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName));
    //CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    CFIndex nPeople = CFArrayGetCount(allPeople); // bugfix who synced contacts with facebook
    NSMutableArray* items = [[NSMutableArray alloc] init];

    
    if (!allPeople || !nPeople) {
        NSLog(@"people nil");
    }
    
    
    for (int i = 0; i < nPeople; i++) {
        
        @autoreleasepool {
            
            //data model
            Contact *contacts = [[Contact alloc]init];
            User *user = [[User alloc]init];
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            //get First Name
            CFStringRef firstName = (CFStringRef)ABRecordCopyValue(person,kABPersonFirstNameProperty);
            user.firstName = [(__bridge NSString*)firstName copy];
            
            if (firstName != NULL) {
                CFRelease(firstName);
            }
            
            
            //get Last Name
            CFStringRef lastName = (CFStringRef)ABRecordCopyValue(person,kABPersonLastNameProperty);
            user.lastName = [(__bridge NSString*)lastName copy];
            
            if (lastName != NULL) {
                CFRelease(lastName);
            }
            
            
            if (!user.firstName) {
                user.firstName = @"";
            }
            
            if (!user.lastName) {
                user.lastName = @"";
            }
            
            
            contacts.user = user;
            
            contacts.contactId = ABRecordGetRecordID(person);
            contacts.nickName = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
            
            //get Phone Numbers
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for(CFIndex i=0; i<ABMultiValueGetCount(multiPhones); i++) {
                @autoreleasepool {
                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                    NSString *phoneNumber = CFBridgingRelease(phoneNumberRef);
                    if (phoneNumber != nil){
                        contacts.phoneNumber = phoneNumber;
                        [phoneNumbers addObject:phoneNumber];
                        
                    }
                    //NSLog(@"All numbers %@", phoneNumbers);
                }
            }
            
            if (multiPhones != NULL) {
                CFRelease(multiPhones);
            }
            
            [items addObject:contacts];
            
#ifdef DEBUG
            
#endif
            
            
        }
    }
    CFRelease(allPeople);
    CFRelease(addressBook);
    CFRelease(source);
  
    
    return items;
    
}


-(void) getData:(int) offset keyword:(NSString*) keyword{
    
    NSDictionary *inventory = @{@"offset" : [NSString stringWithFormat:@"%d",offset],
                                @"keyword" : keyword
                                };
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/search/contact/by/keyword" params:inventory tag:@"getData"];
    
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
                [self getData:self.offset keyword:self.keyword];
                
                NSLog(@"load more rows");
            }
            
            
        }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.view endEditing:YES];
    
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
        return YES;
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.myObject = [[NSMutableArray alloc] init];
    self.offset = 0;
    self.loaded = false;
    self.keyword = searchText;
    [self getData:self.offset keyword:self.keyword];
}

#pragma mark - table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.myObject.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Contact *data=[self.myObject objectAtIndex:indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%@ %@",data.user.firstName,data.user.lastName];
    cell.sub.text = [NSString stringWithFormat:@"%@",data.textStatus];
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.user.picPath.original.path]]
                       placeholderImage:nil];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contact *data =self.myObject[indexPath.row];
    
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if([[self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2] isKindOfClass:[ChatViewController class]])
    {
        ChatViewController *data1 = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
        data1.contactToSend = data;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self performSegueWithIdentifier:@"showChat" sender:self];
    }
    
   
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    
    if ([tag isEqualToString:@"getData"])
    {
    
        NSError* error = nil;
        self.response = [[ContactResponse alloc] initWithDictionary:data error:&error];
        
        
        
        if(self.response.responseStat.status){
            
            for(int i=0;i<self.response.responseData.count;i++)
            {
                [self.myObject addObject:self.response.responseData[i]];
            }
            
        }
        
        self.isData = self.response.responseStat.status;
        self.loaded = self.response.responseStat.status;
        self.offset = (self.response.responseStat.status) ? self.offset+1 : self.offset;
        [self.tableData reloadData];

    }
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
    if ([tag isEqualToString:@"getData"])
    {
        [self.tableData reloadData];
    }
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showChat"])
    {
        NSIndexPath *indexPath = [self.tableData indexPathForSelectedRow];
        ChatViewController *data = [segue destinationViewController];
        Contact *post = self.myObject[indexPath.row];
        data.hidesBottomBarWhenPushed = YES;
        data.contact = post;
        
    }

}


@end
