//
//  ContactsData.h
//  Group SMS
//
//  Created by Workspace Infotech on 7/2/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContactsData : NSObject

@property (strong,nonatomic) NSString* firstNames;
@property (strong,nonatomic) NSString* lastNames;
@property (assign,nonatomic) int contactId;
@property (strong,nonatomic) NSString* fullname;
@property (strong,nonatomic) UIImage* image;
@property (strong,nonatomic) NSMutableArray* numbers;
@property (strong,nonatomic) NSMutableArray* emails;
@property (strong,nonatomic) NSString* phone;
@property (assign,nonatomic) BOOL check;


@end
