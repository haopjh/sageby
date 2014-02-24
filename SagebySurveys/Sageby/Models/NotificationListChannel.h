//
//  NotificationChannel.h
//  Sageby
//
//  Created by LuoJia on 23/10/12.
//
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface NotificationListChannel : NSObject <JSONSerializable>

@property (nonatomic, readonly, strong) NSMutableArray *notificationList;
@property (nonatomic, strong) NSString *errorMsg;

@end
