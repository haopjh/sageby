//
//  VoucherPurchasedChannel.m
//  Sageby
//
//  Created by LuoJia on 14/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VoucherPurchasedChannel.h"

@implementation VoucherPurchasedChannel
@synthesize userCredit;
@synthesize qrCodePathString;
@synthesize reference;
@synthesize securityCode;
@synthesize qrCodePathURL;
@synthesize resultMsg;
@synthesize errorMsg;

- (id)init
{
    self = [super init];
    if(self){
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    @try {
        NSDictionary *redeem = [d objectForKey:@"redeems"];
        [self setUserCredit:[[redeem objectForKey:@"user_credit"] floatValue]];
        
        if ([redeem objectForKey:@"QR_code_path_url"]) {
            NSString *qrCodePathURLString = [redeem objectForKey:@"QR_code_path_url"];
            [self setQrCodePathURL:[NSURL URLWithString:qrCodePathURLString]];
        }
        
        if ([redeem objectForKey:@"QR_code_path_string"]) {
            [self setQrCodePathString:[redeem objectForKey:@"QR_code_path_string"]];
        }
        
        if ([redeem objectForKey:@"security_code"]) {
            [self setSecurityCode:[redeem objectForKey:@"security_code"]];
        }
        
        if ([redeem objectForKey:@"reference"]) {
            [self setReference:[redeem objectForKey:@"reference"]];
        }
        
        if ([redeem objectForKey:@"result"]) {
            [self setResultMsg:[redeem objectForKey:@"result"]];
        }
    }
    @catch (NSException *e) {
        [self setErrorMsg:@"Please update Sageby Surveys to latest version"];
    }
    @finally {
        NSDictionary *redeem = [d objectForKey:@"redeems"];
        if ([redeem objectForKey:@"error"]) {
            [self setErrorMsg:[redeem objectForKey:@"error"]];
        }
    }
}


@end
