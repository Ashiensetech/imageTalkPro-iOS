//
//  ChatExtra.h
//  ImageTalk
//
//  Created by Workspace Infotech on 12/1/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "User.h"
#import "Job.h"
#import "AppCredential.h"

@interface ChatExtra : JSONModel

@property (strong,nonatomic) NSString <Optional> *placeId;
@property (strong,nonatomic) NSString <Optional> *icon;
@property (strong,nonatomic) NSString <Optional> *name;
@property (strong,nonatomic) NSString <Optional> *googlePlaceId;
@property (strong, nonatomic) NSString <Optional> *textStatus;
@property (strong, nonatomic) User <Optional> *user;
@property (strong, nonatomic) Job <Optional> *job;
@property (strong, nonatomic) NSString <Optional> *phoneNumber;
@property (strong, nonatomic) NSString <Optional> *createdDate;
@property (strong, nonatomic) NSString <Optional>  *contactCreatedDate;
@property (strong, nonatomic) NSString <Optional> *nickName;
@property (strong, nonatomic) NSString <Optional> *formattedAddress;
@property (strong, nonatomic) NSString <Optional> *countryName;
@property (strong,nonatomic) NSString <Optional> *caption;
@property (strong,nonatomic) NSString <Optional> *base64Img;
@property (strong,nonatomic) Picture <Optional> *pictures;
@property (strong,nonatomic) AppCredential <Optional> *appCredential;
@property (strong,nonatomic) NSString <Optional> *chatId;
@property (strong,nonatomic) NSString <Optional> *tmpChatId;
@property (strong,nonatomic) NSString <Optional> *extra;



@property (assign,nonatomic) int timer;
@property (assign,nonatomic) BOOL tookSnapShot;
@property (assign, nonatomic) int  id;
@property (assign, nonatomic) int  contactId;
@property (assign, nonatomic) BOOL  favorites;
@property (assign, nonatomic) BOOL  isBlock;
@property (assign, nonatomic) float  rating;
@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lng;
@property (assign,nonatomic) int type;
@property (assign,nonatomic) BOOL recevice;
@property (assign,nonatomic) BOOL send;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;


@end
