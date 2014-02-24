//
//  SageByAPIStore.m
//  Sageby
//
//  Created by LuoJia on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SageByAPIStore.h"
#import "SagebyAPIConnection.h"
#import "SurveyChannel.h"
#import "UserProfileChannel.h"
#import "UserChannel.h"
#import "AvailableSurveyListChannel.h"
#import "SurveyQuestion.h"
#import "CreditChannel.h"
#import "RewardChannel.h"
#import "VoucherChannel.h"
#import "VoucherPurchasedChannel.h"
#import "NotificationListChannel.h"

#import "AppDelegate.h"

static NSString *kAppVersion = @"iOS1.2";

@implementation SageByAPIStore

+ (SageByAPIStore *)sharedStore
{
    static SageByAPIStore *apiStore = nil;
    if (!apiStore)
        apiStore = [[SageByAPIStore alloc] init];
    
    return apiStore;
}

# pragma User API
- (void)fetchSessionWithEmail:(NSString *)email withPassword:(NSString *)password withCompletion:(void (^)(UserChannel *obj, NSHTTPURLResponse *res, NSError *err))block;
{
    //prepare json data
    NSArray *keys = [NSArray arrayWithObjects:@"app_version", @"email", @"password", nil];
    NSArray *objects = [NSArray arrayWithObjects:kAppVersion, email, password, nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSString *requestString = [NSString stringWithFormat:@"https://www.sageby.com/API/user.php?t=login"];
    NSMutableURLRequest *request = [self createRequestConnectionWithData:dict withRequestURL:requestString];
    
    //prepare the connection
    UserChannel *channel = [[UserChannel alloc] init];
    SagebyAPIConnection *connection = [[SagebyAPIConnection alloc] initWithRequest:request];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    //start http connection
    [connection start];
}

- (void)fetchSessionWithFacebookID:(NSString *)facebookID withAccessToken:(NSString *)accessToken withCompletion:(void (^)(UserChannel *obj, NSHTTPURLResponse *res, NSError *err))block;
{
    //prepare json data
    NSArray *keys = [NSArray arrayWithObjects:@"app_version", @"facebookID", @"facebook_access_token", nil];
    NSArray *objects = [NSArray arrayWithObjects:kAppVersion, facebookID, accessToken, nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    //prepate http request connection
    NSString *requestString = [NSString stringWithFormat:@"https://www.sageby.com/API/user.php?t=login"];
    NSMutableURLRequest *request = [self createRequestConnectionWithData:dict withRequestURL:requestString];
    
    //prepare the type of object to be used for json parsing
    UserChannel *channel = [[UserChannel alloc] init];
    SagebyAPIConnection *connection = [[SagebyAPIConnection alloc] initWithRequest:request];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    //start http connection
    [connection start];
}

- (void)fetchUserProfileWithUserID:(int) userID withCompletion:(void (^)(UserProfileChannel *obj, NSHTTPURLResponse *res, NSError *err))block
{
    //prepare json data
    NSArray *keys = [NSArray arrayWithObjects:@"app_version", @"user_id", nil];
    NSArray *objects = [NSArray arrayWithObjects:kAppVersion, [NSNumber numberWithInt:userID], nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    //prepate http request connection
    NSString *requestString = [NSString stringWithFormat:@"https://www.sageby.com/API/user.php?t=getUserProfile"]; //will be changing to SIGNUP API
    NSMutableURLRequest *request = [self createRequestConnectionWithData:dict withRequestURL:requestString];
    
    //prepare the type of object to be used for json parsing
    UserProfileChannel *channel = [[UserProfileChannel alloc] init];
    SagebyAPIConnection *connection = [[SagebyAPIConnection alloc] initWithRequest:request];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    //start http connection
    [connection start];
}

# pragma Rewards API
- (void)fetchAvailableVouchersWithUserID:(int)userID withCompletion:(void (^)(RewardChannel *obj, NSHTTPURLResponse *res, NSError *err))block
{
    //prepare json data
    NSArray *keys = [NSArray arrayWithObjects:@"app_version", @"user_id", nil];
    NSArray *objects = [NSArray arrayWithObjects:kAppVersion, [NSNumber numberWithInt:userID], nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    //prepate http request connection
    NSString *requestString = [NSString stringWithFormat:@"https://www.sageby.com/API/reward.php?t=getAvailableRedemptions"];
    NSMutableURLRequest *request = [self createRequestConnectionWithData:dict withRequestURL:requestString];
    
    //prepare the type of object to be used for json parsing
    RewardChannel *channel = [[RewardChannel alloc] init];
    SagebyAPIConnection *connection = [[SagebyAPIConnection alloc] initWithRequest:request];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    //start http connection
    [connection start];
}

- (void)purchaseVoucherWithUserID:(int)userID withVoucherID:(int)voucherID withVoucherCost:(double)voucherCost withCompletion:(void (^)(VoucherPurchasedChannel *obj, NSHTTPURLResponse *res, NSError *err))block;
{
    //prepare json data
    NSArray *keys = [NSArray arrayWithObjects:@"app_version", @"user_id", @"voucher_sku_id", @"voucher_cost", nil];
    NSArray *objects = [NSArray arrayWithObjects:kAppVersion, [NSNumber numberWithInt:userID], [NSNumber numberWithInt:voucherID], [NSNumber numberWithDouble:voucherCost], nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    //prepate http request connection
    NSString *requestString = [NSString stringWithFormat:@"https://www.sageby.com/API/reward.php?t=redeemVoucher"];
    NSMutableURLRequest *request = [self createRequestConnectionWithData:dict withRequestURL:requestString];
    
    //prepare the type of object to be used for json parsing
    VoucherPurchasedChannel *channel = [[VoucherPurchasedChannel alloc] init];
    SagebyAPIConnection *connection = [[SagebyAPIConnection alloc] initWithRequest:request];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    //start http connection
    [connection start];
}

- (void)purchaseVoucherWithUserID:(int)userID withVoucherID:(int)voucherID withVoucherCost:(double)voucherCost withUserInfo:(UserProfileChannel *)user withCompletion:(void (^)(VoucherPurchasedChannel *obj, NSHTTPURLResponse *res, NSError *err))block
{
    //prepare json data
    NSArray *keys = [NSArray arrayWithObjects:@"app_version", @"user_id", @"voucher_sku_id", @"voucher_cost", @"user_profile_first_name", @"user_profile_last_name", @"user_address_street", @"user_address_unit", @"user_address_country_code", @"user_address_postal_code",nil];
    NSArray *objects = [NSArray arrayWithObjects:kAppVersion, [NSNumber numberWithInt:userID], [NSNumber numberWithInt:voucherID], [NSNumber numberWithDouble:voucherCost], [user user_profile_first_name], [user user_profile_last_name], [user user_address_street], [user user_address_unit], [user user_address_country_code], [user user_address_postal_code], nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    //prepate http request connection
    NSString *requestString = [NSString stringWithFormat:@"https://www.sageby.com/API/reward.php?t=redeemVoucher"];
    NSMutableURLRequest *request = [self createRequestConnectionWithData:dict withRequestURL:requestString];
    
    //prepare the type of object to be used for json parsing
    VoucherPurchasedChannel *channel = [[VoucherPurchasedChannel alloc] init];
    SagebyAPIConnection *connection = [[SagebyAPIConnection alloc] initWithRequest:request];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    //start http connection
    [connection start];
}

- (void)fetchUserRedemptionsWithUserID:(int)userID withCompletion:(void (^)(RewardChannel *obj, NSHTTPURLResponse *res, NSError *err))block
{
    //prepare json data
    NSArray *keys = [NSArray arrayWithObjects:@"app_version", @"user_id", nil];
    NSArray *objects = [NSArray arrayWithObjects:kAppVersion, [NSNumber numberWithInt:userID], nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    //prepate http request connection
    NSString *requestString = [NSString stringWithFormat:@"https://www.sageby.com/API/reward.php?t=getUsersRedemptions"];
    NSMutableURLRequest *request = [self createRequestConnectionWithData:dict withRequestURL:requestString];
    
    //prepare the type of object to be used for json parsing
    RewardChannel *channel = [[RewardChannel alloc] init];
    SagebyAPIConnection *connection = [[SagebyAPIConnection alloc] initWithRequest:request];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    //start http connection
    [connection start];
}

#pragma Survey API
- (void)fetchAvailableSurveysWithUserID:(int) userID withCompletion:(void (^)(AvailableSurveyListChannel *obj, NSHTTPURLResponse *res, NSError *err))block;
{
    //prepare json data
    NSArray *keys = [NSArray arrayWithObjects:@"app_version", @"user_id", nil];
    NSArray *objects = [NSArray arrayWithObjects:kAppVersion, [NSNumber numberWithInt: userID], nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    //prepate http request connection
    NSString *requestString = [NSString stringWithFormat:@"https://www.sageby.com/API/survey.php?t=getAvailableSurveys"];
//    NSString *requestString = [NSString stringWithFormat:@"http://10.4.16.29/API/survey.php?t=getAvailableSurveys"];
    NSMutableURLRequest *request = [self createRequestConnectionWithData:dict withRequestURL:requestString];
    
    //prepare the type of object to be used for json parsing
    AvailableSurveyListChannel *channel = [[AvailableSurveyListChannel alloc] init];
    SagebyAPIConnection *connection = [[SagebyAPIConnection alloc] initWithRequest:request];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    //start http connection
    [connection start];
}

- (void)fetchSurveyDetailsWithUserID:(int)userID withTaskID:(int)taskID withCompletion:(void (^)(SurveyChannel *obj, NSHTTPURLResponse *res, NSError *err))block
{
    //prepare json data
    NSArray *keys = [NSArray arrayWithObjects:@"app_version", @"user_id", @"task_id", nil];
    NSArray *objects = [NSArray arrayWithObjects:kAppVersion, [NSNumber numberWithInt: userID], [NSNumber numberWithInt: taskID], nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    //prepate http request connection
    NSString *requestString = [NSString stringWithFormat:@"https://www.sageby.com/API/survey.php?t=getSurveyDetails"];
    NSMutableURLRequest *request = [self createRequestConnectionWithData:dict withRequestURL:requestString];
    
    //prepare the type of object to be used for json parsing
    SurveyChannel *channel = [[SurveyChannel alloc] init];
    SagebyAPIConnection *connection = [[SagebyAPIConnection alloc] initWithRequest:request];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    //start http connection
    [connection start];
}

- (void)fetchSurveyNextQuestionWithUserID:(int) userID withSurvey:(SurveyChannel *)surveyChannel withCompletion:(void (^)(SurveyChannel *obj, NSHTTPURLResponse *, NSError *err))block;
{
    //prepare json data
    SurveyQuestion *currentQuestion = [[surveyChannel surveyQuestions] lastObject];
    NSMutableArray *questions = [[NSMutableArray alloc] initWithObjects:currentQuestion, nil];
    NSMutableArray *ans = [self generateUserAnswerDict:questions];
    NSArray *keys = [NSArray arrayWithObjects:@"app_version", @"user_id", @"task_id", @"answers", nil];
    NSArray *objects = [NSArray arrayWithObjects:kAppVersion, [NSNumber numberWithInt:userID],
                        [NSNumber numberWithInt:[surveyChannel taskID]], ans,nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    //prepate http request connection
    NSString *requestString = [NSString stringWithFormat:@"https://www.sageby.com/API/survey.php?t=getNextQuestion"];
    NSMutableURLRequest *request = [self createRequestConnectionWithData:dict withRequestURL:requestString];
    
    //prepare the type of object to be used for json parsing
    SurveyChannel *channel = [[SurveyChannel alloc] init];
    SagebyAPIConnection *connection = [[SagebyAPIConnection alloc] initWithRequest:request];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    //start http connection
    [connection start];
}

- (void)submitSurveyWithUserID:(int)userID withSurvey:(SurveyChannel *)surveyChannel withCompletion:(void (^)(CreditChannel *obj, NSHTTPURLResponse *res, NSError *err))block
{
    //prepare json data
    NSMutableArray *questions = [surveyChannel surveyQuestions];
    NSMutableArray *ans = [self generateUserAnswerDict:questions];
    NSArray *keys = [NSArray arrayWithObjects:@"app_version", @"user_id", @"task_id", @"answers", nil];
    NSArray *objects = [NSArray arrayWithObjects:kAppVersion, [NSNumber numberWithInt:userID], [NSNumber numberWithInt:[surveyChannel taskID]], ans, nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    //prepate http request connection
    NSString *requestString = [NSString stringWithFormat:@"https://www.sageby.com/API/survey.php?t=submitSurvey"];
    NSMutableURLRequest *request = [self createRequestConnectionWithData:dict withRequestURL:requestString];
    
    //prepare the type of object to be used for json parsing
    CreditChannel *channel = [[CreditChannel alloc] init];
    SagebyAPIConnection *connection = [[SagebyAPIConnection alloc] initWithRequest:request];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    //start http connection
    [connection start];
}

- (void)fetchUserNotificationsWithUserID:(int)userID withCompletion:(void (^)(NotificationListChannel *obj, NSHTTPURLResponse *res, NSError *err))block
{
    //prepare json data
    NSArray *keys = [NSArray arrayWithObjects:@"app_version", @"user_id", nil];
    NSArray *objects = [NSArray arrayWithObjects:kAppVersion, [NSNumber numberWithInt:userID], nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    //prepate http request connection
    NSString *requestString = [NSString stringWithFormat:@"https://www.sageby.com/API/user.php?t=getNotifications"];
    NSMutableURLRequest *request = [self createRequestConnectionWithData:dict withRequestURL:requestString];
    
    //prepare the type of object to be used for json parsing
    NotificationListChannel *channel = [[NotificationListChannel alloc] init];
    SagebyAPIConnection *connection = [[SagebyAPIConnection alloc] initWithRequest:request];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    
    //start http connection
    [connection start];
}

- (NSDictionary *)submitSurveyWithSynchronousRequestWithUserID:(int)userID withSurvey:(SurveyChannel *)surveyChannel
{
    //prepare json data
    NSArray *keys = [NSArray arrayWithObjects:@"app_version", @"user_id", @"task_id", @"end_survey_url", nil];
    NSArray *objects = [NSArray arrayWithObjects:kAppVersion, [NSNumber numberWithInt:userID], [NSNumber numberWithInt:[surveyChannel taskID]], [surveyChannel endSurveyURL], nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    //prepate http request connection
    NSString *requestString = [NSString stringWithFormat:@"https://www.sageby.com/API/survey.php?t=submitSurvey"];
    NSMutableURLRequest *request = [self createRequestConnectionWithData:dict withRequestURL:requestString];
    
    NSURLResponse *response = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSMutableArray*returnKeys = [NSMutableArray arrayWithObjects:@"data", nil];
    NSMutableArray *returnObjects = [NSMutableArray arrayWithObjects:data, nil];
    if (response) {
        [returnKeys addObject:@"response"];
        [returnObjects addObject:response];
//        NSLog(@"response %@", response);
//        NSHTTPURLResponse *rep = (NSHTTPURLResponse *)response;
//        NSLog(@"response %d", [rep statusCode]);
    }
    if (err) {
        [returnKeys addObject:@"error"];
        [returnObjects addObject:err];
//        NSLog(@"err %@", err);
//        NSLog(@"err code %d", [err code]);
    }

    NSDictionary *returnDict = [NSDictionary dictionaryWithObjects:returnObjects forKeys:returnKeys];
    return returnDict;
}

- (NSMutableURLRequest *)createRequestConnectionWithData:(NSDictionary *)dict withRequestURL:(NSString *)url
{
//    NSDictionary *postDict = [NSDictionary dictionaryWithObject:dict forKey:@"post"];
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString* newStr = [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];
    NSString*postStr = [NSString stringWithFormat:@"post=%@", newStr];
    NSData*postData = [postStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSString *strData = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonData: %@", strData);
    
    //prepate http request connection
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];
    [req setURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:@"POST"];
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:postData];
    
    return req;
}

- (NSMutableArray *)generateUserAnswerDict:(NSMutableArray *)surveyQuestions
{
    NSMutableArray *answers = [[NSMutableArray alloc] init];
    NSArray *keys = [NSArray arrayWithObjects:@"question_id", @"selected_options", nil];
    for (SurveyQuestion *question in surveyQuestions) {
        NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithInt:[question questionID]], [question userAnswers], nil];
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        [answers addObject:dict];
    }
    return answers;
}

@end
