//
//  ShareMoodViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/9/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "ShareMoodViewController.h"
#import "CustomCollectionViewCell.h"
#import "JSONHTTPClient.h"
#import "ToastView.h"
#import "UIImageView+WebCache.h"
#import "TagViewController.h"
#import "ApiAccess.h"
#import "HorizontalTableViewCell.h"
#import "UploadMoodViewController.h"

@interface ShareMoodViewController ()

@end

@implementation ShareMoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    [[ApiAccess getSharedInstance] setDelegate:self];

    self.myObject = [[NSMutableArray alloc] init];
    self.myObjectCategory = [[NSMutableArray alloc] init];
    
   
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    self.offset = 0;
    self.loaded = false;
    [self getData:self.offset];
    //[self getCategoryData];
    
   
    

}


-(void) viewDidAppear:(BOOL)animated
{
    [[ApiAccess getSharedInstance] setDelegate:self];
}

-(void) getData:(int) offset{
    
    NSDictionary *inventory = @{@"offset" : [NSString stringWithFormat:@"%d",offset]};
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/stickers/get/for/post" params:inventory tag:@"getStickerData"];

}


-(void) getCategoryData{
    
    NSDictionary *inventory = @{};
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/stickers/get/paid/category" params:inventory tag:@"getStickerCategoryData"];

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
            [self getData:self.offset];
            
            NSLog(@"load more rows");
        }
        
        
    }
    
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


- (IBAction)cancel:(id)sender {
    
    self.singleView.hidden = true;
    self.collectionData.hidden = false;
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
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
 
    Sticker *data = self.myObject[indexPath.row];
    [self.imageSticker sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/sticker?p=%@",baseurl,data.path]]
                  placeholderImage:nil];
    
    [self performSegueWithIdentifier:@"tag" sender:self];
    

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"photoCell";
    
    NSLog(@"ihdifgs");
    
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    
    cell.image.contentMode = UIViewContentModeCenter;
    Sticker *data = self.myObject[indexPath.row];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@app/media/access/sticker?p=%@",baseurl,data.path]]
                  placeholderImage:nil];
    
     NSLog(@"%@",[NSMutableString stringWithFormat:@"%@app/media/access/sticker?p=%@",baseurl,data.path]);
    
    
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    
    if ([tag isEqualToString:@"getStickerData"])
    {
        NSError* error = nil;
        self.response = [[StickerResponse alloc] initWithDictionary:data error:&error];
        
        
        
        if(self.response.responseStat.status){
            
            for(int i=0;i<self.response.responseData.count;i++)
            {
                [self.myObject addObject:self.response.responseData[i]];
            }
            
        }
        
        
        
        self.isData = self.response.responseStat.status;
        self.loaded = self.response.responseStat.status;
        self.offset = (self.response.responseStat.status) ? self.offset+1 : self.offset;
        [self.collectionData reloadData];
       
        
    }
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
    if ([tag isEqualToString:@"getStickerData"])
    {
         [self.collectionData reloadData];
    }
    
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"tag"])
    {
        UploadMoodViewController *data = [segue destinationViewController];
        data.pic  = self.imageSticker.image;
        data.type = 2;
        data.myObjectSelection = self.myObjectSelection;
        
    }
}


@end
