//
//  VoucherPurchasedChannel.h
//  Sageby
//
//  Created by LuoJia on 14/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface VoucherPurchasedChannel : NSObject <JSONSerializable>

@property (nonatomic, assign) float userCredit;
@property (nonatomic, strong) NSString *qrCodePathString;
@property (nonatomic, strong) NSString *securityCode;
@property (nonatomic, strong) NSString *reference;
@property (nonatomic, strong) NSURL *qrCodePathURL;
@property (nonatomic, strong) NSString *resultMsg;

@property (nonatomic, strong) NSString *errorMsg;

@end
