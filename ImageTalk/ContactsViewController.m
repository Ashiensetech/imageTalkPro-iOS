//
//  ContactsViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "ContactsViewController.h"
#import "CustomTableViewCell.h"
#import "ContactsTableViewCell.h"
#import "AppCredential.h"
#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import "ToastView.h"
#import "ApiAccess.h"
#import "FriendsProfileViewController.h"
#import <math.h>

@interface ContactsViewController ()

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden= NO;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
    [[ApiAccess getSharedInstance] setDelegate:self];

    self.contactStringArray = [[NSMutableArray alloc] init];
    self.contactCount = 0;
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion((__bridge ABAddressBookRef)(self), ^(bool granted, CFErrorRef error) {
            if (granted) {
                self.contactsData=[self getAllContacts];
                self.contactsTitles = [[self.contactsData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            } else {
                
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        self.contactsData=[self getAllContacts];
        self.contactsTitles = [[self.contactsData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        
    }
    else {
    }
    
    
    self.myObject = [[NSMutableArray alloc] init];
    
    self.offset = 0;
    self.loaded = false;
    self.keyword = @"";
    [self getData:self.offset keyword:self.keyword];
    
    
    self.app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    [self importContacts];
    
    [self.tableData reloadData];
}

-(void) getData:(int) offset keyword:(NSString*) keyword{
    
    NSDictionary *inventory = @{
                                @"offset" :[NSString stringWithFormat:@"%d",offset],
                                @"keyword" : keyword
                                };
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/search/contact/by/keyword" params:inventory tag:@"getData"];

}


-(void) importContacts{
    
    if(self.contactStringArray.count > 0)
    {
        for (int i=0; i<self.contactStringArray.count; i++)
        {
            NSString *conString = self.contactStringArray[i];
            NSDictionary *inventory = @{@"contacts" :conString};
            [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/contact/findmatch" params:inventory tag:@"findmatch"];
        }
    }
    else
    {
        
        NSDictionary *inventory = @{@"contacts" :self.contactString};
        [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/contact/findmatch" params:inventory tag:@"findmatch"];
    }
    
}

-(void) addContacts{
    
    NSDictionary *inventory = @{@"app_login_credential_id" :self.contactAddString};
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/contact/add" params:inventory tag:@"getData"];
    
}

- (NSMutableDictionary *)getAllContacts {
    
        CFErrorRef *error = nil;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        CFArrayRef allPeople = (ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName));
         //CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
         CFIndex nPeople = CFArrayGetCount(allPeople); // bugfix who synced contacts with facebook
         NSMutableDictionary* items = [[NSMutableDictionary alloc] init];
         NSMutableArray* itemA=[[NSMutableArray alloc] init];
         NSMutableArray* itemB=[[NSMutableArray alloc] init];
         NSMutableArray* itemC=[[NSMutableArray alloc] init];
         NSMutableArray* itemD=[[NSMutableArray alloc] init];
         NSMutableArray* itemE=[[NSMutableArray alloc] init];
         NSMutableArray* itemF=[[NSMutableArray alloc] init];
         NSMutableArray* itemG=[[NSMutableArray alloc] init];
         NSMutableArray* itemH=[[NSMutableArray alloc] init];
         NSMutableArray* itemI=[[NSMutableArray alloc] init];
         NSMutableArray* itemJ=[[NSMutableArray alloc] init];
         NSMutableArray* itemK=[[NSMutableArray alloc] init];
         NSMutableArray* itemL=[[NSMutableArray alloc] init];
         NSMutableArray* itemM=[[NSMutableArray alloc] init];
         NSMutableArray* itemN=[[NSMutableArray alloc] init];
         NSMutableArray* itemO=[[NSMutableArray alloc] init];
         NSMutableArray* itemP=[[NSMutableArray alloc] init];
         NSMutableArray* itemQ=[[NSMutableArray alloc] init];
         NSMutableArray* itemR=[[NSMutableArray alloc] init];
         NSMutableArray* itemS=[[NSMutableArray alloc] init];
         NSMutableArray* itemT=[[NSMutableArray alloc] init];
         NSMutableArray* itemU=[[NSMutableArray alloc] init];
         NSMutableArray* itemV=[[NSMutableArray alloc] init];
         NSMutableArray* itemW=[[NSMutableArray alloc] init];
         NSMutableArray* itemX=[[NSMutableArray alloc] init];
         NSMutableArray* itemY=[[NSMutableArray alloc] init];
         NSMutableArray* itemZ=[[NSMutableArray alloc] init];
    
        if (!allPeople || !nPeople) {
            NSLog(@"people nil");
        }


        for (int i = 0; i < nPeople; i++) {
        
        @autoreleasepool {
            
            //data model
            ContactsData *contacts = [ContactsData new];
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            //get First Name
            CFStringRef firstName = (CFStringRef)ABRecordCopyValue(person,kABPersonFirstNameProperty);
            contacts.firstNames = [(__bridge NSString*)firstName copy];
            
            if (firstName != NULL) {
                CFRelease(firstName);
            }
            
            
            //get Last Name
            CFStringRef lastName = (CFStringRef)ABRecordCopyValue(person,kABPersonLastNameProperty);
            contacts.lastNames = [(__bridge NSString*)lastName copy];
            
            if (lastName != NULL) {
                CFRelease(lastName);
            }
            
            
            if (!contacts.firstNames) {
                contacts.firstNames = @"";
            }
            
            if (!contacts.lastNames) {
                contacts.lastNames = @"";
            }
            
            
            
            
            contacts.contactId = ABRecordGetRecordID(person);
            //append first name and last name
            contacts.fullname = [NSString stringWithFormat:@"%@ %@", contacts.firstNames, contacts.lastNames];
            
            //get Phone Numbers
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for(CFIndex i=0; i<ABMultiValueGetCount(multiPhones); i++) {
                @autoreleasepool {
                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                    NSString *phoneNumber = CFBridgingRelease(phoneNumberRef);
                    if (phoneNumber != nil){
                        contacts.phone = phoneNumber;
                        [phoneNumbers addObject:phoneNumber];
                        
                    }
                    //NSLog(@"All numbers %@", phoneNumbers);
                }
            }
            
            if (multiPhones != NULL) {
                CFRelease(multiPhones);
            }
            
            [contacts setNumbers:phoneNumbers];
            
            if(i>=50 && fmod(i, 50)==0)
            {
                self.contactString = [NSString stringWithFormat:@"%@]",self.contactString];
                NSCharacterSet *unwantedChars = [NSCharacterSet characterSetWithCharactersInString:@"+()-"];
                self.contactString = [[self.contactString componentsSeparatedByCharactersInSet:unwantedChars] componentsJoinedByString: @""];
                self.contactString = [self.contactString stringByReplacingOccurrencesOfString:@" " withString:@""];
                [self.contactStringArray addObject:self.contactString];
                self.contactString = @"";
            }

            
            self.contactString = (fmod(i, 50)==0) ?[NSString stringWithFormat:@"[\"%@\"",contacts.phone]:[NSString stringWithFormat:@"%@,\"%@\"",self.contactString,contacts.phone];
            
             NSLog(@"Person is: %@", self.contactString);
            
            NSLog(@"MOD RESULT : %f",fmod(i, 50));
            
            
            if ([contacts.firstNames hasPrefix:@"A"] || [contacts.firstNames hasPrefix:@"a"]) {
                [itemA addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"B"] || [contacts.firstNames hasPrefix:@"b"]) {
                [itemB addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"C"] || [contacts.firstNames hasPrefix:@"c"]) {
               [itemC addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"D"] || [contacts.firstNames hasPrefix:@"d"]) {
                [itemD addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"E"] || [contacts.firstNames hasPrefix:@"e"]) {
                [itemE addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"F"] || [contacts.firstNames hasPrefix:@"f"]) {
                [itemF addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"G"] || [contacts.firstNames hasPrefix:@"g"]) {
               [itemG addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"H"] || [contacts.firstNames hasPrefix:@"h"]) {
               [itemH addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"I"] || [contacts.firstNames hasPrefix:@"i"]) {
               [itemI addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"J"] || [contacts.firstNames hasPrefix:@"j"]) {
             [itemJ addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"K"] || [contacts.firstNames hasPrefix:@"k"]) {
               [itemK addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"L"] || [contacts.firstNames hasPrefix:@"l"]) {
                [itemL addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"M"] || [contacts.firstNames hasPrefix:@"m"]) {
               [itemM addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"N"] || [contacts.firstNames hasPrefix:@"n"]) {
                [itemN addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"O"] || [contacts.firstNames hasPrefix:@"o"]) {
               [itemO addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"P"] || [contacts.firstNames hasPrefix:@"p"]) {
               [itemP addObject:contacts];
            }if ([contacts.firstNames hasPrefix:@"Q"] || [contacts.firstNames hasPrefix:@"q"]) {
                [itemQ addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"R"] || [contacts.firstNames hasPrefix:@"r"]) {
               [itemR addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"S"] || [contacts.firstNames hasPrefix:@"s"]) {
                [itemS addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"T"] || [contacts.firstNames hasPrefix:@"t"]) {
                [itemT addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"U"] || [contacts.firstNames hasPrefix:@"u"]) {
               [itemU addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"V"] || [contacts.firstNames hasPrefix:@"v"]) {
                [itemV addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"W"] || [contacts.firstNames hasPrefix:@"w"]) {
               [itemW addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"X"] || [contacts.firstNames hasPrefix:@"x"]) {
                [itemX addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"Y"] || [contacts.firstNames hasPrefix:@"y"]) {
                [itemY addObject:contacts];
            }
            if ([contacts.firstNames hasPrefix:@"Z"] || [contacts.firstNames hasPrefix:@"z"]) {
                [itemZ addObject:contacts];
            }
            
            
            
          
            
            
#ifdef DEBUG
           
#endif
            
            
        }
    } //autoreleasepool
    CFRelease(allPeople);
    CFRelease(addressBook);
    CFRelease(source);
    
    if([itemA count]>0){[items setObject:itemA forKey:@"A"];}
    if([itemB count]>0){[items setObject:itemB forKey:@"B"];}
    if([itemC count]>0){[items setObject:itemC forKey:@"C"];}
    if([itemD count]>0){[items setObject:itemD forKey:@"D"];}
    if([itemE count]>0){[items setObject:itemE forKey:@"E"];}
    if([itemF count]>0){[items setObject:itemF forKey:@"F"];}
    if([itemG count]>0){[items setObject:itemG forKey:@"G"];}
    if([itemH count]>0){[items setObject:itemH forKey:@"H"];}
    if([itemI count]>0){[items setObject:itemI forKey:@"I"];}
    if([itemJ count]>0){[items setObject:itemJ forKey:@"J"];}
    if([itemK count]>0){[items setObject:itemK forKey:@"K"];}
    if([itemL count]>0){[items setObject:itemL forKey:@"L"];}
    if([itemM count]>0){[items setObject:itemM forKey:@"M"];}
    if([itemN count]>0){[items setObject:itemN forKey:@"N"];}
    if([itemO count]>0){[items setObject:itemO forKey:@"O"];}
    if([itemP count]>0){[items setObject:itemP forKey:@"P"];}
    if([itemQ count]>0){[items setObject:itemQ forKey:@"Q"];}
    if([itemR count]>0){[items setObject:itemR forKey:@"R"];}
    if([itemS count]>0){[items setObject:itemS forKey:@"S"];}
    if([itemT count]>0){[items setObject:itemT forKey:@"T"];}
    if([itemU count]>0){[items setObject:itemU forKey:@"U"];}
    if([itemV count]>0){[items setObject:itemV forKey:@"V"];}
    if([itemW count]>0){[items setObject:itemW forKey:@"W"];}
    if([itemX count]>0){[items setObject:itemX forKey:@"X"];}
    if([itemY count]>0){[items setObject:itemY forKey:@"Y"];}
    if([itemZ count]>0){[items setObject:itemZ forKey:@"Z"];}
    
    self.contactString = [NSString stringWithFormat:@"%@]",self.contactString];
    
    NSCharacterSet *unwantedChars = [NSCharacterSet characterSetWithCharactersInString:@"()-"];
    self.contactString = [[self.contactString componentsSeparatedByCharactersInSet:unwantedChars] componentsJoinedByString: @""];
    self.contactString = [self.contactString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    return items;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.tableData)
    {
        return [self.contactsTitles count];
    }
    else
    {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableData)
    {
        return [self.contactsTitles objectAtIndex:section];
    }
    else
    {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableData)
    {
        NSString *sectionTitle = [self.contactsTitles objectAtIndex:section];
        NSArray *sectionContacts = [self.contactsData objectForKey:sectionTitle];
        return [sectionContacts count];
    }
    else
    {
        self.mainHeight.constant = self.myObject.count * 50;
        return self.myObject.count;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if(tableView == self.tableData)
    {
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        [header.textLabel setTextColor:[UIColor orangeColor]];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableData)
    {
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];


        NSString *sectionTitle = [self.contactsTitles objectAtIndex:indexPath.section];
        NSArray *sectionContacts = [self.contactsData objectForKey:sectionTitle];
        ContactsData *data=[sectionContacts objectAtIndex:indexPath.row];
        NSString *contactsTitle= [NSString stringWithFormat:@"%@ %@",data.firstNames,data.lastNames];
        cell.label.text = contactsTitle;

        return cell;
    }
    else
    {
        ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        Contact *data=[self.myObject objectAtIndex:indexPath.row];
        cell.name.text = [NSString stringWithFormat:@"%@ %@",data.user.firstName,data.user.lastName];
        cell.sub.text = [NSString stringWithFormat:@"%@",data.textStatus];
        [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.user.picPath.original.path]]
                           placeholderImage:nil];
        
        return cell;
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

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    
    if ([tag isEqualToString:@"getData"])
    {
        NSError* error = nil;
        self.responseC = [[ContactResponse alloc] initWithDictionary:data error:&error];
        
        if(self.responseC.responseStat.status)
        {
            for(int i=0;i<self.responseC.responseData.count;i++)
            {
                [self.myObject addObject:self.responseC.responseData[i]];
            }
          
        }
        
        self.isData = self.responseC.responseStat.status;
        self.loaded = self.responseC.responseStat.status;
        self.offset = (self.responseC.responseStat.status)? self.offset+1:self.offset;
        [self.tableMainData reloadData];
        
    }
    
    if ([tag isEqualToString:@"findmatch"])
    {
        NSError* error = nil;
        self.response = [[ContactsResponse alloc] initWithDictionary:data error:&error];
        
        
        if(self.response.responseData.count>0)
        {
            for(int i=0;i<self.response.responseData.count;i++)
            {
                [self.app.contacts addObject:self.response.responseData[i]];
                AppCredential *data = self.response.responseData[i];
                self.contactAddString = (i==0) ?[NSString stringWithFormat:@"[%d",data.id]:[NSString stringWithFormat:@"%@,%d",self.contactAddString,data.id];
                
            }
            self.contactAddString = [NSString stringWithFormat:@"%@]",self.contactAddString];
            
            [self addContacts];
            
        }

        
    }
    
   
    
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"friendsProfile"])
    {
        NSIndexPath *indexPath = [self.tableMainData indexPathForSelectedRow];
        FriendsProfileViewController *data = [segue destinationViewController];
        Contact *post = self.myObject[indexPath.row];
        data.hidesBottomBarWhenPushed = YES;
        data.owner = (AppCredential*) post;
        
    }
}


@end
