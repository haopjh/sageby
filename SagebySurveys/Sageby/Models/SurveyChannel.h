//
//  SurveyChannel.h
//  Sageby
//
//  Created by LuoJia on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface SurveyChannel : NSObject <JSONSerializable>

@property (nonatomic, assign) int taskID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) int surveyType;
@property (nonatomic, assign) int maximumParticipants;
@property (nonatomic, assign) int currentParticipants;
@property (nonatomic, assign) float creditAmount;
@property (nonatomic, assign) int timeNeeded;
@property (nonatomic, strong) NSURL *remoteURL;
@property (nonatomic, strong) NSString *endSurveyURL;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSString *errorMsg;

// optional variables
@property (nonatomic, assign) BOOL isQuestionRouting;
@property (nonatomic, strong) NSURL *surveyImageFile;

//@property (nonatomic, readonly, strong) NSMutableArray *surveyQuestions;
@property (nonatomic, strong) NSMutableArray *surveyQuestions;

- (BOOL)isLastQuestion:(int)questionID;
- (BOOL)isFirstQuestion:(int)questionID;
- (id)nextQuestion:(int)questionID;
- (NSString *)questionContent:(int)questionID;
- (void)store:(int)questionID userAnswer:(NSMutableArray *)answer;
- (float)userProgress:(int)questionID;

@end
