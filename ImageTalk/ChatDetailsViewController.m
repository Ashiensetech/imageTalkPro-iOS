//
//  ChatDetailsViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 11/17/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "ChatDetailsViewController.h"
#import "ToastView.h"
#import "ChatViewController.h"
#import "AcknowledgementResponse.h"
#import "SocketPhotoResponse.h"

CGFloat const kMinZoomScale = 0.5f;
CGFloat const kMaxZoomScale = 2.2f;
CGFloat const kInitialZoomScale = 0.5f;

@interface ChatDetailsViewController ()

@end

@implementation ChatDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    baseurl = [defaults objectForKey:@"baseurl"];
    socketurl = [defaults objectForKey:@"socketurl"];
    port = [defaults objectForKey:@"port"];
    
    self.body.image = self.image;
    self.privatePhoto.hidden = !self.isPrivate;
    
    self.body.frame = self.scrollView.frame;
    [self.body setContentMode:UIViewContentModeScaleAspectFit];
    [self.scrollView addSubview:self.body];
    [self.body setUserInteractionEnabled:YES];
    [self calculateScrollViewScale];
     self.scrollView.zoomScale = self.initialZoomLevel;
    [self centerScrollViewContents];
  
     self.app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:self.singleTap];
    
   
    
    
   
}



-(void) viewWillAppear:(BOOL)animated
{
    [[[SocektAccess getSharedInstance]getSocket]setDelegate:self];
    [[[SocektAccess getSharedInstance]getSocket] reconnect];
    _chatSocket =[[SocektAccess getSharedInstance]getSocket];
    
    [[TimerAccess getSharedInstance] setDelegate:self];
    
 
    
    if(self.isPrivate && self.data.recevice)
    {
        
      
        
        if (![[TimerAccess getSharedInstance] isChatId:self.data.chatId])
        {
            SocketResponse *response = [[SocketResponse alloc]init];
            
            SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
            
            responseStat.status = true;
            responseStat.tag = @"chat_private_photo_destroy";
            
            response.responseStat = responseStat;
            response.responseData = self.data;
            
            
            
            NSError* error;
            
            NSData *dataR = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
            NSString* jsonString = [[NSString alloc] initWithData:dataR encoding:NSUTF8StringEncoding];
            
            jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
            jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
            
            
            [self.chatSocket sendMessage:jsonString];
            NSLog(@"%@",jsonString);

        }
        
        [[TimerAccess getSharedInstance] timerIntilaizeWithChatId:self.data.chatId duration:self.data.timer];
    }
    
    
    
    

    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)userDidTakeScreenshot {
    
    NSLog(@"Screen shot taken");
    
    if (self.isPrivate && self.data.recevice && !self.isDeleted)
    {
        SocketResponse *response = [[SocketResponse alloc]init];
        
        SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
        
        responseStat.status = true;
        responseStat.tag = @"chat_private_photo_took_snapshot";
        
        response.responseStat = responseStat;
        response.responseData = self.data;
        
        NSError* error;
        
        NSData *dataR = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
        NSString* jsonString = [[NSString alloc] initWithData:dataR encoding:NSUTF8StringEncoding];
        
        jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
        
        [self.chatSocket sendMessage:jsonString];

    }
    
   
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) timerTickWithChatId:(NSString *)chatId interval:(int)interval
{
    
    if (self.isPrivate &&  self.data.recevice && [self.data.chatId isEqualToString:chatId]) {
        
        self.interval = interval;
        self.privatePhoto.text  = [NSString stringWithFormat:@"Private Photo : %d Seconds", interval];
        
    }
}

-(void) timerFinishWithChatId:(NSString *)chatId
{
    if (self.isPrivate &&  self.data.recevice && [self.data.chatId isEqualToString:chatId])
    {
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    ChatViewController *data1 = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
    data1.isPrivateDestroyed = true;
    
    [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Scroll View Delegate

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.body.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.body.frame = contentsFrame;
}

#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.body;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    [self centerScrollViewContents];
}

#pragma mark - Rotation handling

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    // Don't do this if the imageview doesnt exist yet.
    if(self.body == nil){
        return;
    }
    [UIView animateWithDuration:duration animations:^{
        self.body.alpha = 0;
        [self centerScrollViewContents];
    }];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    // Don't do this if the imageview doesnt exist yet.
    if(self.body == nil){
        return;
    }
    // Seems we have to tear down and recreate the image view or this wont work.
    [self.body removeFromSuperview];
    UIImage *oldImage = self.body.image;
    self.body = nil;
    self.body = [[UIImageView alloc] initWithImage:oldImage];
    self.body.frame = self.scrollView.frame;
    [self.body setContentMode:UIViewContentModeScaleAspectFit];
    [self.scrollView addSubview:self.body];
    [self.body setUserInteractionEnabled:YES];
    [self calculateScrollViewScale];
    self.scrollView.zoomScale = self.initialZoomLevel;
    [self centerScrollViewContents];
    [UIView animateWithDuration:.5 animations:^{
        self.body.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)calculateScrollViewScale{
    [self.scrollView setContentSize:self.body.frame.size];
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MAX(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = kMaxZoomScale;
    self.initialZoomLevel=minScale;
}


#pragma mark - tcpSocketDelegate
-(void)receivedMessage:(NSString *)data
{
      
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
