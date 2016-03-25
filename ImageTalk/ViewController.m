//
//  ViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ImageTalk";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
    self.startBtn.layer.cornerRadius = 20.0;
    [self.startBtn.layer setMasksToBounds:YES];
    
    self.center.layer.cornerRadius = 50.0;
    [self.center.layer setMasksToBounds:YES];
    
   
}

-(void) viewDidAppear:(BOOL)animated
{
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
