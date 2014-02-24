//
//  CreditChannel.m
//  Sageby
//
//  Created by LuoJia on 23/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreditChannel.h"

@implementation CreditChannel

@synthesize creditedAmount, currentAmount, errorMsg;

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    @try {
        [self setCurrentAmount:[[d objectForKey:@"current_amount"] floatValue]];
        [self setCreditedAmount:[[d objectForKey:@"credited_amount"] floatValue]];
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
