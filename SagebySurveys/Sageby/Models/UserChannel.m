//
//  SessionChannel.m
//  Sageby
//
//  Created by LuoJia on 12/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserChannel.h"
#import "UserProfileChannel.h"

@implementation UserChannel
@synthesize userID, user, errorMsg;

- (id)init
{
    self = [super init];
    if(self){
        //Create the container for the surveyQuestions this channel has;
        user = [[UserProfileChannel alloc] init];
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    @try {
        [self setUserID:[[d objectForKey:@"user_id"]intValue]];
        [user readFromJSONDictionary:d];
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
