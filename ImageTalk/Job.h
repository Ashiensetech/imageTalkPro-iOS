//
//  Job.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/2/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "Picture.h"

@interface Job : JSONModel

@property (assign, nonatomic) int  id;
@property (assign, nonatomic) int  appCredentialId;
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *description;
@property (strong, nonatomic) Picture  *icons;
@property (assign, nonatomic) float  price;
@property (assign, nonatomic) int  paymentType;
@property (strong, nonatomic) NSString  *createdDate;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
