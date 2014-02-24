//
//  UserProfile.h
//  Sageby
//
//  Created by Lion User on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface UserProfileChannel: NSObject <JSONSerializable> 

@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *referrelURL;
@property (nonatomic, strong) NSURL *userImageFile;
@property (nonatomic, assign) float userCredit;

@property (nonatomic, strong) NSString *user_profile_first_name;
@property (nonatomic, strong) NSString *user_profile_last_name;
@property (nonatomic, strong) NSString *user_address_street;
@property (nonatomic, strong) NSString *user_address_unit;
@property (nonatomic, strong) NSString *user_address_country_code;
@property (nonatomic, strong) NSString *user_address_postal_code;

@property (nonatomic, strong) NSString *errorMsg;

@end
