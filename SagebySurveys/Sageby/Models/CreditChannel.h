//
//  CreditChannel.h
//  Sageby
//
//  Created by LuoJia on 23/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface CreditChannel : NSObject <JSONSerializable> 

@property (nonatomic, assign) float creditedAmount;
@property (nonatomic, assign) float currentAmount;

@property (nonatomic, strong) NSString *errorMsg;

@end
