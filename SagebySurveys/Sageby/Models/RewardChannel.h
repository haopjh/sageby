//
//  StoreChannel.h
//  Sageby
//
//  Created by LuoJia on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"
@class VoucherChannel;

@interface RewardChannel : NSObject <JSONSerializable>

@property (nonatomic, readonly, strong) NSMutableArray *voucherList;
@property (nonatomic, strong) NSString *errorMsg;

//- (NSInteger)countVoucherList:(BOOL)available;
- (NSMutableArray *)getVoucherListSectionCategory;
- (NSMutableArray *)getVoucherListStatusCategory;
- (NSMutableArray *)getVoucherListWithSection:(NSString *)section;
- (NSMutableArray *)getPurchasedVoucherListWithSection:(NSString *)section;

@end
