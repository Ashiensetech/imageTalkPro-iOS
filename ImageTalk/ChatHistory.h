//
//  ChatHistory.h
//  ImageTalk
//
//  Created by Workspace Infotech on 11/11/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import "JSONModel.h"
#import "Contact.h"
#import "Chat.h"

@protocol ChatHistory 

@end

@interface ChatHistory : JSONModel

@property (strong, nonatomic) Contact  *contact;
@property (strong, nonatomic) NSArray <Chat>  *chat;
@property (assign, nonatomic) int unRead;

@end
