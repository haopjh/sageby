//
//  Voucher.h
//  Sageby
//
//  Created by LuoJia on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface VoucherChannel : NSObject <JSONSerializable>

@property (nonatomic, assign) int voucherID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *qrCodePathString;
@property (nonatomic, strong) NSString *securityCode;
@property (nonatomic, strong) NSString *reference;
@property (nonatomic, assign) BOOL isUsed;
@property (nonatomic, strong) NSURL *qrCodePathURL;
@property (nonatomic, strong) NSURL *voucherImageFile;
@property (nonatomic, readonly, strong) NSMutableArray *voucherCostList;
@property (nonatomic, strong) NSString *resultMsg;

@property (nonatomic, strong) NSMutableArray *vendorAnnotationList;

@property (nonatomic, strong) NSString *errorMsg;

@end
