//
//  ChatViewController.h
//  ImageTalk
//
//  Created by Workspace Infotech on 9/7/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tcpSocketChat.h"
#import "AppDelegate.h"
#import "Contact.h"
#import "ChatResponse.h"
#import "Places.h"
#import "ChatLocation.h"
#import "SocektAccess.h"
#import "ApiAccess.h"
#import "TimerAccess.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ChatViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,tcpSocketChatDelegate,NSStreamDelegate,UITextViewDelegate,UIActionSheetDelegate,ApiAccessDelegate,TimeAccessDelegate,ABPeoplePickerNavigationControllerDelegate>
{
    NSUserDefaults *defaults;
    NSString *baseurl;
    NSString *socketurl;
    NSString *port;
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    NSDate *currentDate;
}

@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
@property (strong, nonatomic) NSMutableDictionary *cImages;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (strong, nonatomic) IBOutlet UIView *myLocationView;
@property (strong, nonatomic) IBOutlet UIView *cancelView;
@property (strong, nonatomic) IBOutlet UIView *contactsView;
@property (strong, nonatomic) IBOutlet UIView *privateView;
@property (strong, nonatomic) IBOutlet UIButton *privatePhoto;
@property (strong, nonatomic) IBOutlet UIButton *photoVideo;
@property (strong, nonatomic) IBOutlet UIButton *myLocation;
@property (strong, nonatomic) IBOutlet UIButton *contacts;
@property (strong, nonatomic) IBOutlet UIButton *cancel;
@property (strong, nonatomic) IBOutlet UIView *actionPicker;
@property (strong, nonatomic) IBOutlet UIButton *send;
@property (strong, nonatomic) UILabel *subtitleView;
@property (strong, nonatomic) IBOutlet UIView *chatTextView;
@property (strong, nonatomic) IBOutlet UITextView *type;
@property (strong, nonatomic) IBOutlet UIView *photoChose;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic)  NSMutableArray *myObject;
@property (strong, nonatomic) IBOutlet UITableView *tableData;
@property (nonatomic,strong) tcpSocketChat* chatSocket;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic,strong) SocektAccess* socketAccess;



@property (strong, nonatomic)  AppDelegate *app;
@property (strong, nonatomic)  Contact *contact;
@property (strong, nonatomic)  Places *placeToSend;
@property (strong, nonatomic)  Contact *contactToSend;
@property (strong, nonatomic)  UIImage *imageToSend;
@property (strong, nonatomic)  ChatResponse *response;
@property (strong, nonatomic) IBOutlet UIButton *profilePic;
@property (strong,nonatomic) NSString* imageName;
@property (assign,nonatomic) int offset;
@property (assign,nonatomic) int timer;
@property (assign,nonatomic) BOOL isData;
@property (assign,nonatomic) BOOL loaded;
@property (assign,nonatomic) BOOL history;
@property (assign,nonatomic) BOOL isSend;
@property (assign,nonatomic) BOOL isPrivate;
@property (assign,nonatomic) BOOL isPrivateDestroyed;
@property (assign,nonatomic) BOOL isVideo;



@end
