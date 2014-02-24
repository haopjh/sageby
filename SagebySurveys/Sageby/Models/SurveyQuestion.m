//
//  SurveyQuestion.m
//  Sageby
//
//  Created by LuoJia on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SurveyQuestion.h"

@implementation SurveyQuestion
@synthesize question, questionID, questionType, answerOptions,userAnswers, optional, isLastQuestion, min, max, increment, errorMsg, questionVC;

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    @try {
        [self setQuestionID:[[d objectForKey:@"question_id"] intValue]];
        [self setQuestion:[d objectForKey:@"question_title"]];
        [self setQuestionType:[d objectForKey:@"question_type"]];
        [self setAnswerOptions:[d objectForKey:@"Options"]];
        [self setOptional:[[d objectForKey:@"is_optional"] boolValue]];
        if ([d objectForKey:@"is_last_question"] != NULL) {
            [self setOptional:[[d objectForKey:@"is_last_question"] boolValue]];
        }
        [self setMin:[[d objectForKey:@"min"] intValue]];
        [self setMax:[[d objectForKey:@"max"] intValue]];
        [self setIncrement:[[d objectForKey:@"increment"] intValue]];
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
