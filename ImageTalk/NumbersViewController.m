//
//  NumbersViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/19/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "NumbersViewController.h"
#import "JSONHTTPClient.h"
#import "ApiAccess.h"
#import "LikesTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ToastView.h"

@interface NumbersViewController ()

@end

@implementation NumbersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:self.singleTap];
    
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    self.myObject = [[NSMutableArray alloc] init];
    
    self.offset = 0;
    self.loaded = false;
    self.keyword = @"";
    [self getData:self.offset keyword:self.keyword];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

-(void) getData:(int) offset keyword:(NSString*) keyword{
    
    NSDictionary *inventory = @{@"offset" : [NSString stringWithFormat:@"%d",offset],
                                @"keyword" : keyword
                                };
    [[ApiAccess getSharedInstance] postRequestWithUrl:self.url params:inventory tag:@"getData"];
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
    LikesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    
    Contact *data = self.myObject[indexPath.row];
    
    
    cell.name.text = [NSString stringWithFormat:@"%@ %@",data.user.firstName,data.user.lastName];
    cell.date.text = [NSString stringWithFormat:@"%@",data.textStatus];
    
    
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.user.picPath.original.path]]placeholderImage:nil];
    
    
    return cell;
    
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
   // self.myObject = [[NSMutableArray alloc] init];
   // self.offset = 0;
   // self.loaded = false;
    self.keyword = searchText;
   // [self getData:self.offset keyword:self.keyword];
}


#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    
    if ([tag isEqualToString:@"getData"])
    {
        
        NSError* error = nil;
        self.response = [[ContactResponse alloc] initWithDictionary:data error:&error];
        
        
        if(self.response.responseStat.status)
        {
            for(int i=0;i<self.response.responseData.count;i++)
            {
                [self.myObject addObject:self.response.responseData[i]];
            }
        }
        
        
        self.isData = self.response.responseStat.status;
        self.loaded = self.response.responseStat.status;
        self.offset = (self.response.responseStat.status) ? self.offset+1 :self.offset;
        [self.tableData reloadData];
        
    }
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
