//
//  NSOutputStream+NSOutputStream_NS.h
//  ImageTalk
//
//  Created by Workspace Infotech on 12/4/15.
//  Copyright © 2015 Workspace Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOutputStream (NSOutputStream_NS)

- (NSData *)currentBytes;

- (void)writeInt32:(int32_t)value;
- (void)writeInt64:(int64_t)value;
- (void)writeDouble:(double)value;
- (void)writeData:(NSData *)data;
- (void)writeString:(NSString *)data;
- (void)writeBytes:(NSData *)data;

@end
