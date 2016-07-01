//
//  StickerShopViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/10/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "StickerShopViewController.h"
#import "JSONHTTPClient.h"
#import "ToastView.h"
#import "ApiAccess.h"
#import "HorizontalTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ShopDetailsViewController.h"

@interface StickerShopViewController ()

@end

@implementation StickerShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
     [[ApiAccess getSharedInstance] setDelegate:self];
    
     self.myObjectCategory = [[NSMutableArray alloc] init];
    
     self.tableData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [ self.tableData setAllowsSelection:YES];
    [self getCategoryData];
}

-(void) getCategoryData{
    
    NSDictionary *inventory = @{};
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/stickers/get/paid/category" params:inventory tag:@"getCategoryData"];

}

#pragma mark - table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myObjectCategory.count;

    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StickerCategory *data = self.myObjectCategory[indexPath.row];
    
    HorizontalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.title.text = data.name;
    cell.subTitle.text = [NSString stringWithFormat:@"%d photos",data.stickers.count];
    
    [cell.coverPic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/sticker?p=%@",baseurl,data.coverPicPath]]
                     placeholderImage:nil];
    
    cell.downloadBtn.tag = indexPath.row;
    
    
    return cell;
    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"from ");
    HorizontalTableViewCell *cell = [self.tableData cellForRowAtIndexPath:indexPath];
   [self performSegueWithIdentifier:@"shopDetails" sender:cell.downloadBtn];
}
#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    
    if ([tag isEqualToString:@"getCategoryData"])
    {
        
        NSError* error = nil;
        self.responseCategory = [[StickerCategoryResponse alloc] initWithDictionary:data error:&error];
        
        
        if(self.responseCategory.responseStat.status){
            
            for(int i=0;i<self.responseCategory.responseData.count;i++)
            {
                [self.myObjectCategory addObject:self.responseCategory.responseData[i]];
                
            }
            
        }
        
        [self.tableData reloadData];
        
    }
    
}


-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
    if ([tag isEqualToString:@"getCategoryData"])
    {
        [self.tableData reloadData];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender {
    
    if ([segue.identifier isEqualToString:@"shopDetails"])
    {
        ShopDetailsViewController *data = [segue destinationViewController];
        StickerCategory *post = self.myObjectCategory[sender.tag];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        HorizontalTableViewCell *cell = (HorizontalTableViewCell*)[self.tableData cellForRowAtIndexPath:indexPath];
        data.hidesBottomBarWhenPushed = YES;
        data.myObject = post.stickers;
        data.name_ = post.name;
        data.image_ = cell.coverPic.image;
        
    }
}


@end
