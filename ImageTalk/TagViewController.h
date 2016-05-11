//
//  TagViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/29/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactResponse.h"
#import "ApiAccess.h"
#import "ZDStickerView.h"

@interface TagViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,ApiAccessDelegate,ZDStickerViewDelegate,UITextViewDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
}


@property (strong, nonatomic) NSMutableArray *myObjectSelection;
@property (strong, nonatomic) NSMutableArray *myObject;
@property (strong, nonatomic) ContactResponse *response;
//@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) IBOutlet UITableView *tableData;
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pictureHeight;
@property (strong, nonatomic) NSString *keyword;
@property (assign,nonatomic) int offset;
@property (assign,nonatomic) BOOL isData;
@property (assign,nonatomic) BOOL loaded;
@property (assign,nonatomic) CGPoint tabPosition;
@property (assign,nonatomic) BOOL selected;
@property (strong, nonatomic) IBOutlet UITextView *customMessage;
@property(strong,nonatomic) NSString * customMessageString;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (assign,nonatomic) int type;
@property (strong, nonatomic) UIImage *pic;
@property (strong,nonatomic)NSMutableArray *tagPostions;
@property (strong, nonatomic) IBOutlet UIView *serachView;


@end
