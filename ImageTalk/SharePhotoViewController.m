//
//  SharePhotoViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 10/2/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "SharePhotoViewController.h"
#import "EditPhotoViewController.h"
#import "ToastView.h"
#import "Contact.h"
#import "TagViewController.h"
#import "ApiAccess.h"

@interface SharePhotoViewController ()

@end

@implementation SharePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.hidden=YES;
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    
     self.mainImage.image = self.image;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [[ApiAccess getSharedInstance] setDelegate:self];
    
    if(self.place)
    {
        self.locationLabel.text = [NSString stringWithFormat:@"%@",self.place.name];
    }
    else
    {
        self.locationLabel.text = @"Add Location";
    }
    
    
    if(self.myObjectSelection.count>0)
    {
        
        for (int i=0; i<self.myObjectSelection.count; i++) {
            
            Contact *data = self.myObjectSelection[i];
            
            self.tagLabel.text = (i==0) ? [NSString stringWithFormat:@"%@",data.user.firstName] : [NSString stringWithFormat:@"%@,%@",self.tagLabel.text,data.user.firstName];
        }
        
    }
    else
    {
        self.tagLabel.text = @"Tag Friends";
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.comment resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)upload:(id)sender {
    
    [self.loading startAnimating];
    [self.comment resignFirstResponder];
    [self.upload setEnabled:false];
   
    NSString *taglist= @"";
    
    if(self.myObjectSelection.count>0)
    {
    
        for (int i=0; i<self.myObjectSelection.count; i++) {
            
            Contact *data = self.myObjectSelection[i];
            
            taglist = (i==0) ? [NSString stringWithFormat:@"[%d",data.id] : [NSString stringWithFormat:@"%@,%d",taglist,data.id];
        }
        
        taglist = [NSString stringWithFormat:@"%@]",taglist];
    }
    
    NSLog(@"TAGLIST %@",taglist);
    
    self.comment.text = [NSString stringWithFormat:@"%@ ",self.comment.text];
    
    NSDictionary *inventory = @{
                                @"description" : self.comment.text,
                                @"photo" : [self imageToString:self.image],
                                @"type" : @"0",
                                @"tagged_list" : taglist,
                                @"places" : (self.place)?self.place.toJSONString:@"",
                                @"Content-Type" : @"charset=utf-8",
                                };
    
   
    [[ApiAccess getSharedInstance] postRequestWithUrl:@"app/wallpost/create" params:inventory tag:@"getPhoto"];

    
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

#pragma mark - ApiAccessDelegate

-(void) receivedResponse:(NSDictionary *)data tag:(NSString *)tag index:(int)index
{
    NSLog(@"%@",tag);
    [self.loading stopAnimating];
    
    if ([tag isEqualToString:@"getPhoto"])
    {
        
        
        NSError* error = nil;
        self.response = [[CreatePostResponse alloc] initWithDictionary:data error:&error];
        [self.upload setEnabled:true];
        
        if(self.response.responseStat.status){
            
            [self performSegueWithIdentifier:@"timeline" sender:self];
        }

        
    }
    
}

-(void) receivedError:(JSONModelError *)error tag:(NSString *)tag
{
    [ToastView showErrorToastInParentView:self.view withText:@"Internet connection error" withDuaration:2.0];
    [self.loading stopAnimating];
    
    if ([tag isEqualToString:@"getPhoto"])
    {
        [self.upload setEnabled:true];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"tag"])
    {
        TagViewController *data = [segue destinationViewController];
        data.pic  = self.image;
        data.type = 0;
        data.myObjectSelection = self.myObjectSelection;
        
    }
    
}


@end
