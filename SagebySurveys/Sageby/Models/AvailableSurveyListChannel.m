//
//  AvailableSurveyListChannel.m
//  Sageby
//
//  Created by LuoJia on 19/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AvailableSurveyListChannel.h"
#import "SurveyChannel.h"

@implementation AvailableSurveyListChannel
@synthesize availableSurveyList, errorMsg;

- (id)init
{
    self = [super init];
    if(self){
        //Create the container for the surveyQuestions this channel has;
        availableSurveyList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    @try {
        NSArray *surveys = [d objectForKey:@"surveys"];
        for(NSDictionary *survey in surveys){
            SurveyChannel *s = [[SurveyChannel alloc] init];
            
            [s readFromJSONDictionary:survey];
            
            [availableSurveyList addObject:s];
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


@end
