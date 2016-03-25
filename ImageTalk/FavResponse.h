//
//  FavResponse.h
//  ImageTalk
//
//  Created by Workspace Infotech on 10/27/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "ResponseStatus.h"
#import "FavData.h"

@interface FavResponse : JSONModel

@property (strong, nonatomic) ResponseStatus  *responseStat;
@property (strong, nonatomic) FavData  *responseData;

@end
