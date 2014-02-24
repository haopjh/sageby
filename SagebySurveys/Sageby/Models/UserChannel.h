//
//  SessionChannel.h
//  Sageby
//
//  Created by LuoJia on 12/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"
@class UserProfileChannel;

@interface UserChannel : NSObject <JSONSerializable>

@property (nonatomic, assign) int userID;
@property (nonatomic, strong) UserProfileChannel *user;

@property (nonatomic, strong) NSString *errorMsg;

@end
