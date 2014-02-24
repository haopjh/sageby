//
//  UserProfile.m
//  Sageby
//
//  Created by Lion User on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserProfileChannel.h"


@implementation UserProfileChannel

@synthesize userName, userEmail, userCredit, userImageFile, facebookID, referrelURL, user_profile_first_name, user_profile_last_name, user_address_street,user_address_unit, user_address_country_code, user_address_postal_code, errorMsg;

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    @try {
        [self setUserName:[d objectForKey:@"user_name"]];
        [self setUserEmail:[d objectForKey:@"user_email"]];
        
        [self setUserCredit:[[d objectForKey:@"user_credit"]floatValue]];
        [self setReferrelURL:[d objectForKey:@"referral_url"]];
        
        NSString *userImageFileString = [d objectForKey:@"user_image_file"];
        [self setUserImageFile:[NSURL URLWithString:userImageFileString]];
        
        [self setUser_profile_first_name:[d objectForKey:@"user_profile_first_name"]];
        [self setUser_profile_last_name:[d objectForKey:@"user_profile_last_name"]];
        [self setUser_address_street:[d objectForKey:@"user_address_street"]];
        [self setUser_address_unit:[d objectForKey:@"user_address_unit"]];
        [self setUser_address_country_code:[d objectForKey:@"user_address_country_code"]];
        [self setUser_address_postal_code:[d objectForKey:@"user_address_postal_code"]];
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

