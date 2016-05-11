//
//  TagViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/29/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "TagViewController.h"
#import "JSONHTTPClient.h"
#import "ToastView.h"
#import "UIImageView+WebCache.h"
#import "TagTableViewCell.h"
#import "ShareLocationViewController.h"
#import "ShareMoodViewController.h"
#import "SharePhotoViewController.h"
#import "ApiAccess.h"
#import "ZDStickerView.h"

@interface TagViewController ()

@end

@implementation TagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"Tag Friends"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden= YES;
    
    self.pictureHeight.constant = self.view.frame.size.width;
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    self.picture.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.picture addGestureRecognizer:singleTap];
    singleTap.cancelsTouchesInView = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.selected = false;
    
    self.myObject = [[NSMutableArray alloc] init];
    
    if(!self.myObjectSelection)
    {
        self.myObjectSelection = [[NSMutableArray alloc] init];
    }
    
    self.offset = 0;
    self.loaded = false;
    self.keyword = @"";
    [self getData:self.offset keyword:self.keyword];
    
    self.picture.image =self.pic;
    
    if(self.type == 1)
    {
        self.pictureHeight.constant = self.view.frame.size.width/2;
        self.picture.contentMode = UIViewContentModeScaleToFill;
        
    }
    else if(self.type == 0)
    {
        
        self.pictureHeight.constant = self.view.frame.size.width;
        self.picture.contentMode = UIViewContentModeScaleToFill;
    }
    else
    {
        self.pictureHeight.constant = 130;
        self.picture.contentMode = UIViewContentModeCenter;
    }
    
    self.tableData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if(!self.tagPostions){
        self.tagPostions = [[NSMutableArray alloc] init];
    }else{
      
        for(int i=0;i<self.tagPostions.count;i++){
            Contact *data = [self.tagPostions[i] valueForKey:@"owner"];
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,50,120,20)]; //or whatever size you need
            myLabel.center =  CGPointMake([[self.tagPostions[i] valueForKey:@"origin_x"]floatValue], [[self.tagPostions[i] valueForKey:@"origin_y"]floatValue]);
            [myLabel setFont:[UIFont systemFontOfSize:12]];
            myLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
            myLabel.textColor = [UIColor whiteColor];
            myLabel.textAlignment = NSTextAlignmentCenter;
            myLabel.text = [NSString stringWithFormat:@"%@  %@",data.user.firstName,data.user.lastName] ;
            
            myLabel.userInteractionEnabled = YES;
            
            UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(labelDragged:)] ;
            [myLabel addGestureRecognizer:gesture];
            
            
            [self.picture addSubview:myLabel];
        }
        
    }
    
    self.customMessage.delegate = self;
//    if(self.customMessageString ==NULL){
//        self.customMessageString =@"custom message...";
//        self.customMessage.textColor = [UIColor lightGrayColor];
//    }
//    self.customMessage.text = self.customMessageString;
    
    [self changeHeight:0];
    [self.serachView setHidden:YES];
    
    self.lblOne = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,20)];
    self.lblOne.center = CGPointMake(self.picture.bounds.size.height/2, self.picture.bounds.size.height/2);
    [self.lblOne setFont:[UIFont systemFontOfSize:12]];
    self.lblOne.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    self.lblOne.textColor = [UIColor whiteColor];
    self.lblOne.textAlignment = NSTextAlignmentCenter;
    self.lblOne.text = [NSString stringWithFormat:@"who's this?"] ;
    [self.picture addSubview:self.lblOne];
    
}

- (void)changeHeight:(CGFloat )height {
    self.heightConstraint.constant = height;
    
    [self.serachView layoutIfNeeded];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self changeHeight:50];
    [self.serachView setHidden:NO];
    [self.searchBar becomeFirstResponder];
    self.tabPosition = [sender locationInView:self.picture];
    
    
    
    
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
    self.selected = true;
    self.pictureHeight.constant = 0;
    self.picture.hidden = true;
    [self.tableData reloadData];
    
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
    
    
    if(self.type == 0)
    {
        
        SharePhotoViewController *data = self.navigationController.viewControllers[3];
        data.myObjectSelection = self.myObjectSelection;
        data.tagList = self.tagPostions;
        data.tagCustomMessage = ([self.customMessage.text isEqualToString: @"custom message..."]) ?@"":self.customMessage.text;
    }
    
    if(self.type == 2)
    {
        ShareMoodViewController *data = self.navigationController.viewControllers[1];
        data.myObjectSelection = self.myObjectSelection;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
-(void) labelDragged :(UIPanGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    CGPoint translation = [gesture translationInView:label];
    
    if(CGRectContainsPoint(self.picture.bounds,CGPointMake(label.center.x + translation.x, label.center.y + translation.y))){
        for(int i=0;i<self.tagPostions.count;i++){
            if([[self.tagPostions[i] valueForKey:@"origin_x"]floatValue]==label.center.x && [[self.tagPostions[i] valueForKey:@"origin_y"]floatValue] == label.center.y){
                NSObject * owner =[self.tagPostions[i] valueForKey:@"owner"];
                [self.tagPostions replaceObjectAtIndex:i withObject:@{@"origin_x": [NSNumber numberWithFloat: label.center.x + translation.x] ,@"origin_y":[NSNumber numberWithFloat: label.center.y + translation.y],@"owner":owner}];
            }
        }
        
        // move label
        label.center = CGPointMake(label.center.x + translation.x,
                                   label.center.y + translation.y);
        
        // reset translation
        [gesture setTranslation:CGPointZero inView:label];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section1");
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
            
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tabPosition.x,self.tabPosition.y,120,20)]; //or whatever size you need
            myLabel.center = self.tabPosition;
            [myLabel setFont:[UIFont systemFontOfSize:12]];
            myLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
            myLabel.textColor = [UIColor whiteColor];
            myLabel.textAlignment = NSTextAlignmentCenter;
            myLabel.text = [NSString stringWithFormat:@"%@  %@",data.user.firstName,data.user.lastName] ;
            myLabel.tag = indexPath.row;
            myLabel.userInteractionEnabled = YES;
            
            UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(labelDragged:)] ;
            [myLabel addGestureRecognizer:gesture];
            
            
            [self.picture addSubview:myLabel];
            
            
            [self.myObjectSelection addObject:self.myObject[indexPath.row]];
            [self.tagPostions addObject:@{@"origin_x": [NSNumber numberWithFloat: self.tabPosition.x] ,@"origin_y":[NSNumber numberWithFloat: self.tabPosition.y],@"owner":self.myObject[indexPath.row] }];
                   }
        else
        {
            [ToastView showToastInParentView:self.view withText:@"Already Tagged This Friend" withDuaration:2.0];
        }
        [self changeHeight:0];
        [self.serachView setHidden:YES];
        [self.lblOne removeFromSuperview];

        self.selected = false;
        [self.view endEditing:YES];
        
        [self.tableData reloadData];
        
        self.picture.hidden = false;
        if(self.type == 1)
        {
            
            self.pictureHeight.constant = self.view.frame.size.width/2;
            self.picture.contentMode = UIViewContentModeScaleToFill;
            
        }
        else if(self.type == 0)
        {
            self.pictureHeight.constant = self.view.frame.size.width;
            self.picture.contentMode = UIViewContentModeScaleToFill;
        }
        else
        {
            self.pictureHeight.constant = 110;
            self.picture.contentMode = UIViewContentModeCenter;
        }
    }
    
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(!self.selected)
    {
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete Tag" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            NSObject *tagItem =[self.tagPostions  objectAtIndex:indexPath.row];
            for (UIView *i in self.picture.subviews){
                if([i isKindOfClass:[UILabel class]]){
                    UILabel *newLbl = (UILabel *)i;
                    if(newLbl.center.x == [[tagItem valueForKey:@"origin_x"] floatValue] && newLbl.center.y == [[tagItem valueForKey:@"origin_y"] floatValue]){
                        [newLbl setHidden:YES];
                        [self.picture willRemoveSubview:newLbl];
                    }
                }
            }
            
            [self.myObjectSelection removeObjectAtIndex:indexPath.row];
            [self.tagPostions removeObjectAtIndex:indexPath.row];
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
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    
    if ([tag isEqualToString:@"getTagData"])
    {
        [self.tableData reloadData];
    }
    
    
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"custom message...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString: @"custom message..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
    
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
