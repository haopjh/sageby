//
//  SurveyChannel.m
//  Sageby
//
//  Created by LuoJia on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SurveyChannel.h"
#import "SurveyQuestion.h"
#import "SageByAPIStore.h"

@implementation SurveyChannel
@synthesize taskID;
@synthesize title;
@synthesize description;
@synthesize maximumParticipants;
@synthesize currentParticipants;
@synthesize creditAmount;
@synthesize timeNeeded;
@synthesize surveyImageFile;
@synthesize surveyQuestions;
@synthesize isQuestionRouting;
@synthesize remoteURL;
@synthesize endSurveyURL;
@synthesize endDate;
@synthesize errorMsg;
@synthesize surveyType;

- (id)init
{
    self = [super init];
    if(self){
        //Create the container for the surveyQuestions this channel has;
        surveyQuestions = [[NSMutableArray alloc] init];
        [self setIsQuestionRouting:NO];
        [self setSurveyImageFile:nil];
        [self setEndSurveyURL:nil];
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    @try {
        [self setTaskID:[[d objectForKey:@"task_id"]intValue]];
        [self setTitle:[d objectForKey:@"title"]];
        [self setDescription:[d objectForKey:@"description"]];
        
        [self setMaximumParticipants:[[d objectForKey:@"maximum_participants"]intValue]];
        [self setCurrentParticipants:[[d objectForKey:@"current_participants"]intValue]];
        [self setCreditAmount:[[d objectForKey:@"credit_amount"]floatValue]];
        [self setTimeNeeded:[[d objectForKey:@"time_needed"]intValue]];
        
        [self setSurveyType:[[d objectForKey:@"type"]intValue]];
        
        NSString *dateString = [d objectForKey:@"enddate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [self setEndDate:[dateFormatter dateFromString:dateString]];
        
        if ([d objectForKey:@"image"]) {
            NSString *surveyImageFileString = [d objectForKey:@"image"];
            [self setSurveyImageFile:[NSURL URLWithString:surveyImageFileString]];
        }
        
        if ([d objectForKey:@"is_question_routing"]) {
            [self setIsQuestionRouting:[[d objectForKey:@"is_question_routing"] boolValue]];
        }
        
        if ([d objectForKey:@"remote_url"]) {
            NSString *surveyURLString = [d objectForKey:@"remote_url"];
            [self setRemoteURL:[NSURL URLWithString:surveyURLString]];
        } else {
            NSArray *questions = [d objectForKey:@"questions"];
            for (int i=0; i<[questions count]; i++) {
                NSDictionary *question = [questions objectAtIndex:i];
                SurveyQuestion *q = [[SurveyQuestion alloc] init];
                [q readFromJSONDictionary:question];
                if (![self isQuestionRouting]) {
                    if (i!=[questions count]-1) {
                        [q setIsLastQuestion:NO];
                    } else {
                        [q setIsLastQuestion:YES];
                    }
                }
                [surveyQuestions addObject:q];
            }
        }
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

- (BOOL)isLastQuestion:(int)questionID
{
    NSArray *questions = [self surveyQuestions];
    SurveyQuestion *lastQuestion = [[self surveyQuestions] lastObject];
    BOOL isLastQuestions = NO;
    for(SurveyQuestion *question in questions){
        if(questionID == [question questionID]){
            if([question isEqual:lastQuestion]){
                isLastQuestions = YES;
                break;
            }
        }
    }
    return isLastQuestions;
}

- (BOOL)isFirstQuestion:(int)questionID
{
    NSArray *questions = [self surveyQuestions];
    SurveyQuestion *firstQuestion = [[self surveyQuestions] objectAtIndex:0];
    BOOL isFirstQuestions = NO;
    for(SurveyQuestion *question in questions){
        if(questionID == [question questionID]){
            if([question isEqual:firstQuestion]){
                isFirstQuestions = YES;
                break;
            }
        }
    }
    return isFirstQuestions;
}

- (SurveyQuestion *)nextQuestion:(int)questionID
{
    static SurveyQuestion *nextQuestion;
    NSArray *questions = [self surveyQuestions];
    BOOL isNextQuestion = NO;
    for(SurveyQuestion *question in questions){
        if(!isNextQuestion){
            if(questionID == [question questionID]){
                isNextQuestion = YES;
            }
        } else {
            nextQuestion = question;
            break;
        }
    }
    return nextQuestion;
}

- (NSString *)questionContent:(int)questionID
{
    NSArray *questions = [self surveyQuestions];
    for(SurveyQuestion *question in questions){
        if(questionID == [question questionID]){
            return [question question];
            break;
        }
    }
    return nil;
}

- (void)store:(int)questionID userAnswer:(NSMutableArray *)answer
{
    NSArray *questions = [self surveyQuestions];
    for(SurveyQuestion *question in questions){
        if(questionID == [question questionID]){
            [question setUserAnswers:answer];
            break;
        }
    }
}

- (float)userProgress:(int)questionID
{
    NSArray *questions = [self surveyQuestions];
    int count = 0;
    for(SurveyQuestion *question in questions){
        count++;
        if(questionID == [question questionID]){
            break;
        }
    }
    float progress = (float)count/[[self surveyQuestions] count];
    return progress;
}


@end
