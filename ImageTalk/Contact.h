//
//  Contact.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/29/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "AppCredential.h"

@protocol Contact

@end

@interface Contact : AppCredential

@property (assign, nonatomic) int  contactId;
@property (strong, nonatomic) NSString  *nickName;
@property (assign, nonatomic) BOOL  favorites;
@property (assign, nonatomic) BOOL  isBlock;
@property (assign, nonatomic) int  rating;
@property (strong, nonatomic) NSString  *contactCreatedDate;

+(BOOL)propertyIsOptional:(NSString*)propertyName;
+(BOOL)propertyIsIgnored:(NSString*)propertyName;

@end
