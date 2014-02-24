//
//  SurveyQuestion.h
//  Sageby
//
//  Created by LuoJia on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface SurveyQuestion : NSObject <JSONSerializable>

@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *questionType;
@property (nonatomic, strong) NSDictionary *answerOptions;
@property (nonatomic, assign) BOOL optional;
@property (nonatomic, assign) BOOL isLastQuestion;
@property (nonatomic, assign) int questionID;
@property (nonatomic, assign) int min;
@property (nonatomic, assign) int max;
@property (nonatomic, assign) int increment;
@property (nonatomic, strong) NSMutableArray *userAnswers;
@property (nonatomic, strong) UIViewController *questionVC;

@property (nonatomic, strong) NSString *errorMsg;

@end
