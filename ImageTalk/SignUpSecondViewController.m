//
//  SignUpSecondViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "SignUpSecondViewController.h"
#import "ToastView.h"
#import "SignUpThirdViewController.h"
#import "JSONHttpClient.h"

@interface SignUpSecondViewController ()

@end

@implementation SignUpSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Phone Number";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    [self setPickerData];
    
    
    self.keyboardBorder=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,1)];
    [self.keyboardBorder setBackgroundColor:[UIColor orangeColor]];
    self.phoneNo.inputAccessoryView = self.keyboardBorder;
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:self.singleTap];
    
    
    
  
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowOrHide:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowOrHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];*/
    
}


-(void)keyboardDidShowOrHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    self.view.frame = newFrame;
    
   
    
    [UIView commitAnimations];
}

- (IBAction)accept:(id)sender {
    
    [self.loading startAnimating];
    if(!self.countryCode)
    {
         [ToastView showToastInParentView:self.view withText:@"Select your country first" withDuaration:2.0];
         [self.loading stopAnimating];
    }
    else if ([self.phoneNo.text isEqualToString:@""])
    {
        [ToastView showToastInParentView:self.view withText:@"Insert your valid phone number" withDuaration:2.0];
        [self.loading stopAnimating];
    }
    else
    {
        NSLog(@"%@",[NSString stringWithFormat:@"%@app/register/number",baseurl]);
        
        [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@app/register/number",baseurl] bodyString:[NSString stringWithFormat:@"phone_number=%d%@",self.countryCode,self.phoneNo.text]
                                       completion:^(NSDictionary *json, JSONModelError *err) {
                                           
                                           NSLog(@"%@",err);
                                           
                                           NSError* error = nil;
                                           self.response = [[Response alloc] initWithDictionary:json error:&error];
                                           
                                           NSLog(@"%@",self.response);
                                           
                                           if(error)
                                           {
                                               [ToastView showToastInParentView:self.view withText:@"Server Unreachable" withDuaration:2.0];
                                           }
                                          
                                           
                                           [self.loading stopAnimating];
                                           
                                           if(self.response.responseStat.status){
                                               
                                                [self performSegueWithIdentifier:@"next" sender:self];
                                           }
                                           
                                       }];

    }
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.phoneNo resignFirstResponder];
}

- (IBAction)cancel:(id)sender {
    
    self.tableData.hidden = true;
    self.allData.hidden = false;
    self.title = @"Phone number";
    self.cancel.hidden = true;
    self.next.hidden = false;
    [self.view addGestureRecognizer:self.singleTap];
}


- (IBAction)selctCountry:(id)sender {
    
    self.tableData.hidden = false;
    self.allData.hidden = true;
    self.title = @"Select Country";
    self.cancel.hidden = false;
    self.next.hidden = true;
    [self.view removeGestureRecognizer:self.singleTap];
}




#pragma mark - table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.responseData.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Country *data = self.data.responseData[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",data.niceName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"+%d",data.phoneCode];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Country *data = self.data.responseData[indexPath.row];
    self.countryCode = data.phoneCode;
    [self.country setTitle:[NSString stringWithFormat:@"+%d %@",data.phoneCode,data.name] forState:UIControlStateNormal];
    self.tableData.hidden = true;
    self.allData.hidden = false;
    self.title = @"Phone Number";
    self.cancel.hidden = true;
    self.next.hidden = false;
    [self.view addGestureRecognizer:self.singleTap];
}

-(void) setPickerData{
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@utility/get/countries",baseurl]);
    
    [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@utility/get/countries",baseurl] bodyString:@""
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                       
                                       NSLog(@"%@",err);
                                       
                                       NSError* error = nil;
                                       self.data = [[CountryResponse alloc] initWithDictionary:json error:&error];
                                       
                                       
                                       
                                       
                                       if(self.data.responseStat.status){
                                           NSLog(@"%@",self.data);
                                           [self.tableData reloadData];
                                           
                                       }
                                       
                                       
                                       
                                   }];
}




- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"next"])
    {
        UINavigationController *navController = [segue destinationViewController];
        SignUpThirdViewController *data = (SignUpThirdViewController *)([navController viewControllers][0]);
        data.phone = [NSString stringWithFormat:@"%d%@",self.countryCode,self.phoneNo.text];
      
    }
}


@end
