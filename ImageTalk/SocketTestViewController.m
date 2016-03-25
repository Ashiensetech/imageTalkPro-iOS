//
//  SocketTestViewController.m
//  ImageTalk
//
//  Created by Workspace Infotech on 1/12/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import "SocketTestViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SocketResponse.h"
#import "ChatPhoto.h"
#import "ChatVideo.h"
#import "ToastView.h"

@interface SocketTestViewController ()

@end

@implementation SocketTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[[SocektAccess getSharedInstance]getSocket]setDelegate:self];
    [[[SocektAccess getSharedInstance]getSocket] reconnect];
    _chatSocket =[[SocektAccess getSharedInstance]getSocket];
    
    TSocketClient *transport = [[TSocketClient alloc] initWithHostname:@"27.147.149.178" port:9028];
    TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    server = [[thriftServiceChatTransportClient alloc] initWithProtocol:protocol];
    self.app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@",self.app.authCredential.accessToken);
    
    NSString *token = [server getToken:self.app.authCredential.accessToken];
    [defaults setValue:token forKey:@"socket_token"];
    
   
    
    

}

-(void)moviePlaybackDidFinish:(NSNotification*)aNotification {
   // [self dismissMoviePlayerViewControllerAnimated];
   // [[NSNotificationCenter defaultCenter] removeObserver:self
   //                                       name:MPMoviePlayerPlaybackDidFinishNotification
   //                                       object:nil];
}


- (IBAction)play:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://27.147.149.178:9020/transfer/file?v=420/chat/media/video/50.mp4"];
    
    MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    
    [mpvc.moviePlayer setContentURL:url];
    
    [self presentMoviePlayerViewControllerAnimated:mpvc];
}

-(void)viewDidDisappear:(BOOL)animated
{
}



- (IBAction)normalTransfer:(id)sender {
    
    TextChat *data = [[TextChat alloc]init];
    data.tmpChatId = @"";
    
    NSData *textFieldUTF8Data = [@"hello" dataUsingEncoding: NSUTF8StringEncoding];
    data.text =  [[NSString alloc] initWithData:textFieldUTF8Data encoding:NSUTF8StringEncoding];
    data.appCredential = (AppCredential*)self.app.authCredential;
    data.send = true;
    data.recevice = false;
    data.createdDate = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    
    NSError* error;
    
    SocketResponse *response = [[SocketResponse alloc]init];
    
    SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
    
    responseStat.status = true;
    responseStat.tag = @"textchat";
    
    
    response.responseStat = responseStat;
    response.responseData = data;
    
    
    
    
    NSData *dataR = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonString = [[NSString alloc] initWithData:dataR encoding:NSUTF8StringEncoding];
    
    jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
    
    [self.chatSocket sendMessage:jsonString];

}

- (IBAction)thriftTransfer:(id)sender
{
   // UIImage *image = [UIImage imageNamed:@"body.png"];
   // NSData *data = UIImagePNGRepresentation(image);
   // [server sendFile:data];
    self.isVideo = false;
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
 
}



- (IBAction)thriftTransferFile:(id)sender {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"black" ofType:@"mp4"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    ChatVideo *dataChat = [[ChatVideo alloc]init];
    dataChat.caption = @"";
    dataChat.appCredential = (AppCredential*)self.app.authCredential;
    dataChat.send = true;
    dataChat.recevice = false;
    dataChat.createdDate = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
 
    VideoDetails *video = [[VideoDetails alloc]init];
    
    dataChat.video = video;
    
    
    NSError* error;
    
    SocketResponse *response = [[SocketResponse alloc]init];
    
    SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
    
    responseStat.status = true;
    responseStat.tag = @"";
    
    response.responseStat = responseStat;
    response.responseData = dataChat;
    
    
    
    
    NSData *dataR = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonString = [[NSString alloc] initWithData:dataR encoding:NSUTF8StringEncoding];
    
    jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
    
    [server sendVideo:self.app.authCredential.id token:[defaults objectForKey:@"socket_token"] socketResponse:jsonString bufferedByte:data fileName:@"black.mp4"];
   //self.isVideo = true;
   //[self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
   
    
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (self.isVideo)
    {
        NSLog(@"Video");
        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    }   
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   
  
    
    if (self.isVideo)
    {
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
            NSString *moviePath = [videoUrl path];
            
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:moviePath]];
                self.isVideo = false;
            }
        }
    }
     
    else
    
    {
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        NSData *data = UIImagePNGRepresentation(image);
        
        ChatPhoto *dataChat = [[ChatPhoto alloc]init];
        dataChat.tmpChatId = @"";
        dataChat.caption = @"";
        dataChat.appCredential = (AppCredential*)self.app.authCredential;
        dataChat.send = true;
        dataChat.recevice = false;
        dataChat.createdDate = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        dataChat.base64Img = @" ";
        dataChat.tookSnapShot = false;
    
        
        NSError* error;
        
        SocketResponse *response = [[SocketResponse alloc]init];
        
        SocketResponseStat *responseStat = [[SocketResponseStat alloc]init];
        
        responseStat.status = true;
        responseStat.tag = @"chatprivatephoto_transfer";
        
        response.responseStat = responseStat;
        response.responseData = dataChat;
        
        
        
        
        NSData *dataR = [NSJSONSerialization dataWithJSONObject:[response toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
        NSString* jsonString = [[NSString alloc] initWithData:dataR encoding:NSUTF8StringEncoding];
        
        NSLog(@"Error : %@",jsonString);
        
        jsonString=  [[jsonString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        jsonString = [NSString stringWithFormat:@"%@\n",jsonString];
        
        NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
        {
            ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
            [server sendPicture:self.app.authCredential.id token:[defaults objectForKey:@"socket_token"] socketResponse:jsonString bufferedByte:data fileName:[imageRep filename]];
            
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
              
    }
    
    NSLog(@"End");
    
      [self dismissViewControllerAnimated:YES completion:NULL];
    
    

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
    
    return [imageData base64EncodedStringWithOptions:0];
}

- (UIImage *) stringToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}



#pragma mark - tcpSocketDelegate
-(void)receivedMessage:(NSString *)data
{
    NSError* err = nil;
    SocketResponse *response = [[SocketResponse alloc] initWithString:data error:&err];

    
    [ToastView showErrorToastInParentView:self.view withText:@"Pushback Received" withDuaration:2.0];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
