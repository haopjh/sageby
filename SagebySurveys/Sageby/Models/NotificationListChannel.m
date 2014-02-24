//
//  NotificationChannel.m
//  Sageby
//
//  Created by LuoJia on 23/10/12.
//
//

#import "NotificationListChannel.h"
#import "Notification.h"

@implementation NotificationListChannel

@synthesize notificationList;
@synthesize errorMsg;

- (id)init
{
    self = [super init];
    if(self){
        notificationList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    @try {
        NSArray *notifications = [d objectForKey:@"notifications"];
        for(NSDictionary *notification in notifications){
            Notification *n = [[Notification alloc] init];
            [n readFromJSONDictionary:notification];
            [notificationList addObject:n];
        }
    }
    @catch (NSException *e) {
        [self setErrorMsg:@"Please update Sageby Surveys to latest version"];
    }
    @finally {
        if ([d objectForKey:@"error"]) {
            [self setErrorMsg:[d objectForKey:@"error"]];
        }
    }
}


@end
