//
//  FriendsProfileViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/28/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "FriendsProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "CommentsViewController.h"
#import "LikesViewController.h"
#import "AssetManager.h"
#import "ToastView.h"
#import "ApiAccess.h"
#import "Contact.h"
#import "ChatViewController.h"
#import "CustomCollectionViewCell.h"
#import "UIImageView+WebCache.m"
#import "DetailsViewController.h"

@interface FriendsProfileViewController ()

@end

@implementation FriendsProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.title = [NSString stringWithFormat:@"%@ %@",self.owner.user.firstName,self.owner.user.lastName];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden= YES;
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    
    self.profilePic.layer.cornerRadius = 45;
    [self.profilePic.layer setMasksToBounds:YES];
    
    self.textStatus.text = (self.owner.textStatus) ? self.owner.textStatus : @"No status update";

    
    [self.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,self.owner.user.picPath.original.path]]
                       placeholderImage:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableData addSubview:self.refreshControl];
    
    
    self.myObject = [[NSMutableArray alloc] init];
    
    self.offset = 0;
    self.loaded = false;
    [self getData:self.offset];
}

-(void) viewDidAppear:(BOOL)animated
{
    [[ApiAccess getSharedInstance] setDelegate:self];
    self.tabBarController.tabBar.hidden= YES;
}

- (void)refresh{
    self.offset = 0;
    self.loaded = false;
    self.myObject = nil;
    self.myObject = [[NSMutableArray alloc] init];
    [self getData:self.offset];
    [self.refreshControl endRefreshing];
}

-(void) getData:(int) offset{
    
    NSDictionary *inventory = @{@"offset" : [NSString stringWithFormat:@"%d",offset],
                                @"other_app_credential_id" : [NSString stringWithFormat:@"%d",self.owner.id],
                                @"limit":@"20"
                                };
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/get/others" params:inventory tag:@"getData"];
    
    [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@app/wallpost/get/others",baseurl] bodyString:[NSString stringWithFormat:@"limit=20&offset=%d&other_app_credential_id=%d",offset,self.owner.id]
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                       
                                       
                                   }];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
   
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
       self.collectionHeight.constant = self.collectionData.frame.size.width/6*ceil(self.myObject.count/3);
    }
    else
    {
        self.collectionHeight.constant =self.collectionData.frame.size.width/3*ceil(self.myObject.count/3);
    }
    
    
    
    return self.myObject.count;
}



-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return CGSizeMake(self.collectionData.frame.size.width/6-1,self.collectionData.frame.size.width/6-1);
    }
    else
    {
        return CGSizeMake(self.collectionData.frame.size.width/3-1,self.collectionData.frame.size.width/3-1);
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     self.post = self.myObject[indexPath.row];
     [self performSegueWithIdentifier:@"showDetails" sender:self];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"photoCell";
    
    NSLog(@"Row %d %f",indexPath.row,ceil(self.myObject.count/3));
    
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor darkGrayColor];
    WallPost *data = self.myObject[indexPath.row];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/pictures?p=%@",baseurl,data.picPath]]
                                         placeholderImage:nil];
    
    
    if (ceil(indexPath.row+1/3) == ceil(self.myObject.count/3)) {
        
        if(self.isData && self.loaded)
        {
            
            self.loaded = false;
            [self getData:self.offset];
            
            NSLog(@"load more rows");
        }
    }

    
    return cell;
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
         //   [self getData:self.offset];
            
         //   NSLog(@"load more rows");
        }
        
        
    }
    
}

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    
    if ([tag isEqualToString:@"getData"])
    {
        NSError* error = nil;
        self.data = [[TimelineResponse alloc] initWithDictionary:data error:&error];
        NSLog(@"%@",self.data);
        
        if(self.data.responseStat.status){
            
            for(int i=0;i<self.data.responseData.count;i++)
            {
                [self.myObject addObject:self.data.responseData[i]];
            }
          
        }
        
        
        self.isData = self.data.responseStat.status;
        self.loaded = self.data.responseStat.status;
        self.offset = (self.data.responseStat.status) ? self.offset+1 : self.offset;
        [self.collectionData reloadData];
        
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender {
    
   
    
    
    if ([segue.identifier isEqualToString:@"showDetails"])
    {
        DetailsViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.data = self.post;
        
    }
    
    if ([segue.identifier isEqualToString:@"showChat"])
    {
        
        ChatViewController *data = [segue destinationViewController];
        data.hidesBottomBarWhenPushed = YES;
        data.contact = (Contact*) self.owner;
        
    }
    
    
    
    
    
}


@end
