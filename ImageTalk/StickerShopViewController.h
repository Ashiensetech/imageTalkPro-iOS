//
//  StickerShopViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/10/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickerCategoryResponse.h"
#import "ApiAccess.h"

@interface StickerShopViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ApiAccessDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}

@property (strong, nonatomic) IBOutlet UITableView *tableData;
@property (strong, nonatomic)  NSMutableArray *myObjectCategory;
@property (nonatomic, strong) StickerCategoryResponse *responseCategory;

@end
