//
//  SignUpThirdViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "SignUpThirdViewController.h"
#import "SignUpFourthViewController.h"
#import "ToastView.h"
#import "JSONHttpClient.h"

@interface SignUpThirdViewController ()

@end

@implementation SignUpThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Verify";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    [ToastView showToastInParentView:self.view withText:@"Varification token is sent" withDuaration:2.0];
    
    self.keyboardBorder=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,1)];
    [self.keyboardBorder setBackgroundColor:[UIColor orangeColor]];
    self.phoneNo.inputAccessoryView = self.keyboardBorder;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    
    self.callme.layer.cornerRadius = 25.0;
    [self.callme.layer setMasksToBounds:YES];
   
    
    self.callme.frame = CGRectInset(self.phoneNo.frame, -1.0f, -1.0f);
    self.callme.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.callme.layer.borderWidth = 1.0f;
    
   
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.phoneNo resignFirstResponder];
}

- (IBAction)signUp:(id)sender {
    
    [self.loading startAnimating];
    
    [JSONHTTPClient postJSONFromURLWithString:[NSString stringWithFormat:@"%@app/register/verifytoken",baseurl] bodyString:[NSString stringWithFormat:@"phone_number=%@&token=%@",self.phone,self.phoneNo.text]
                                   completion:^(NSDictionary *json, JSONModelError *err) {
                                       
                                       NSLog(@"%@",err);
                                       
                                       NSError* error = nil;
                                       self.response = [[Response alloc] initWithDictionary:json error:&error];
                                       
                                       
                                       if(error)
                                       {
                                           [ToastView showToastInParentView:self.view withText:@"Server Unreachable" withDuaration:2.0];
                                       }
                                       else
                                       {
                                           [ToastView showToastInParentView:self.view withText:self.response.responseStat.msg withDuaration:2.0];
                                       }
                                       
                                       [self.loading stopAnimating];
                                       
                                       
                                       if(self.response.responseStat.status){
                                           
                                           [self performSegueWithIdentifier:@"next" sender:self];
                                       }
                                       
                                   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"next"])
    {
        UINavigationController *navController = [segue destinationViewController];
        SignUpFourthViewController *data = (SignUpFourthViewController *)([navController viewControllers][0]);
        data.phone = self.phone;
        data.token = self.phoneNo.text;
    }
}


@end
