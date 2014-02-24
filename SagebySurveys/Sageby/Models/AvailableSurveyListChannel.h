//
//  AvailableSurveyListChannel.h
//  Sageby
//
//  Created by LuoJia on 19/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"
@class SurveyChannel;

@interface AvailableSurveyListChannel : NSObject <JSONSerializable>

//@property (nonatomic, readonly, strong) NSMutableArray *availableSurveyList;
@property (nonatomic, strong) NSMutableArray *availableSurveyList;
@property (nonatomic, strong) NSString *errorMsg;

@end
