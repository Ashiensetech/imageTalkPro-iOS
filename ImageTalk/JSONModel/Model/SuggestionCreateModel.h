//
//  SuggestionCreateModel.h
//  Traffic
//
//  Created by Workspace Infotech on 6/29/15.
//  Copyright (c) 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"

@interface SuggestionCreateModel : JSONModel

@property (assign, nonatomic) BOOL isLogin;
@property (assign, nonatomic) BOOL status;
@property (strong, nonatomic) NSString  *message;


@end
