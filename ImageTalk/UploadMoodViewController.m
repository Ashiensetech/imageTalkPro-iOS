//
//  UploadMoodViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/10/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "UploadMoodViewController.h"
#import "TagTableViewCell.h"
#import "JSONHTTPClient.h"
#import "ToastView.h"
#import "ApiAccess.h"
#import "UIImageView+WebCache.h"

@interface UploadMoodViewController ()

@end

@implementation UploadMoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"Share Moods"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden= YES;
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //[self.view addGestureRecognizer:self.singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.selected = false;
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    
    self.myObject = [[NSMutableArray alloc] init];
    self.myObjectSelection = [[NSMutableArray alloc] init];
    self.offset = 0;
    self.loaded = false;
    self.keyword = @"";
    [self getData:self.offset keyword:self.keyword];
    
    self.picture.image =self.pic;

}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

-(void)keyboardDidShow:(NSNotification *)notification
{
   
}

-(void)keyboardDidHide:(NSNotification *)notification
{
   
    
}

-(void) getData:(int) offset keyword:(NSString*) keyword{

    NSDictionary *inventory = @{@"offset" : [NSString stringWithFormat:@"%d",offset],
                                @"keyword" : keyword
                                };
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/search/contact/by/keyword" params:inventory tag:@"getTagData"];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(self.selected)
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
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.view endEditing:YES];
    
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"Check");
    
    self.selected = true;
    [self.tableData reloadData];
    self.pictureHeight.constant = 0;
    self.picture.hidden = true;
    
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


- (IBAction)done:(id)sender {
    
    [self.loading startAnimating];
    [self.customMsg resignFirstResponder];
    
    
    
    NSLog(@"%@app/wallpost/create?%@",baseurl,[NSString stringWithFormat:@"description=%@photo=%@",self.customMsg.text,[self imageToString:self.picture.image]]);
    
    self.customMsg.text = [NSString stringWithFormat:@"%@ ",self.customMsg.text];
    
    NSString *taglist= @"";
    
    if(self.myObjectSelection.count>0)
    {
        
        for (int i=0; i<self.myObjectSelection.count; i++) {
            
            Contact *data = self.myObjectSelection[i];
            
            taglist = (i==0) ? [NSString stringWithFormat:@"[%d",data.id] : [NSString stringWithFormat:@"%@,%d",taglist,data.id];
        }
        
        taglist = [NSString stringWithFormat:@"%@]",taglist];
    }
    
    
    NSDictionary *inventory = @{
                                @"description" : self.customMsg.text,
                                @"photo" : [self imageToString:self.picture.image],
                                @"type" : @"2",
                                @"tagged_list" : taglist,
                                };
    
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/create" params:inventory tag:@"createPost"];

}

-(NSString*) imageToString : (UIImage*) image{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    return [imageData base64Encoding];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.selected)
    {
        return self.myObject.count;
    }
    else
    {
        return self.myObjectSelection.count;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    
    Contact *data = (self.selected)?self.myObject[indexPath.row]:self.myObjectSelection[indexPath.row];
    
    
    cell.title.text = [NSString stringWithFormat:@"%@ %@",data.user.firstName,data.user.lastName];
    
    
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.user.picPath.original.path]]placeholderImage:nil];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.selected)
    {
        BOOL shouoldAdd = YES;
        Contact *data = self.myObject[indexPath.row];
        
        for (int i=0;i<self.myObjectSelection.count; i++) {
            
            
            Contact *data1 = self.myObjectSelection[i];
            
            if(data.id == data1.id)
            {
                shouoldAdd = NO;
            }
        }
        
        if(shouoldAdd)
        {
            [self.myObjectSelection addObject:self.myObject[indexPath.row]];
        }
        else
        {
            [ToastView showToastInParentView:self.view withText:@"Already Tagged This Friend" withDuaration:2.0];
        }
        
        NSLog(@"Check");
        
        self.selected = false;
        [self.view endEditing:YES];
        
        [self.tableData reloadData];
        
        self.picture.hidden = false;
        self.pictureHeight.constant = 110;
        self.picture.contentMode = UIViewContentModeCenter;
    }
    
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(!self.selected)
    {
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete Tag" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            NSLog(@"Delete");
            
            [self.myObjectSelection removeObjectAtIndex:indexPath.row];
            [self.tableData reloadData];
            
            
        }];
        
        deleteAction.backgroundColor = [UIColor redColor];
        
        
        return @[deleteAction];
    }
    else
        return nil;
    
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    [self.loading stopAnimating];
    
    if ([tag isEqualToString:@"getTagData"])
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
    
    if ([tag isEqualToString:@"createPost"])
    {
        NSError* error = nil;
        self.responseCreate = [[CreatePostResponse alloc] initWithDictionary:data error:&error];
        
        if(self.responseCreate.responseStat.status){
            [self performSegueWithIdentifier:@"timeline" sender:self];
        }
    }

    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    [self.loading stopAnimating];
    
    if ([tag isEqualToString:@"getTagData"])
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
