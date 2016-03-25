//
//  SocketTestViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 1/12/16.
//  Copyright © 2016 Workspace Infotech. All rights reserved.
//

#import "ViewController.h"
#import "TSocketClient.h"
#import "TBinaryProtocol.h"
#import "ViewController.h"
#import "SocektAccess.h"
#import "ChatTransport.h"

@interface SocketTestViewController : ViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,tcpSocketChatDelegate>
{
    thriftServiceChatTransportClient *server;
    NSString *imagename;
}


@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (nonatomic,assign) BOOL isVideo;
@property (nonatomic,strong) tcpSocketChat* chatSocket;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic,strong) AppDelegate *app;

@end
