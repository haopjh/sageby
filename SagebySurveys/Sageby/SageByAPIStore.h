//
//  SageByAPIStore.h
//  Sageby
//
//  Created by LuoJia on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SurveyChannel;
@class UserProfileChannel;
@class UserChannel;
@class AvailableSurveyListChannel;
@class CreditChannel;
@class RewardChannel;
@class SurveyChannel;
@class VoucherChannel;
@class VoucherPurchasedChannel;
@class RedemptionType;
@class NotificationListChannel;

@interface SageByAPIStore : NSObject

+ (SageByAPIStore *)sharedStore;

- (NSMutableURLRequest *)createRequestConnectionWithData:(NSDictionary *)dict withRequestURL:(NSString *)url;

- (NSMutableArray *)generateUserAnswerDict:(NSMutableArray *)surveyQuestions;


- (void)fetchSessionWithEmail:(NSString *)email withPassword:(NSString *)password withCompletion:(void (^)(UserChannel *obj, NSHTTPURLResponse *res, NSError *err))block;

- (void)fetchSessionWithFacebookID:(NSString *)facebookID withAccessToken:(NSString *)accessToken withCompletion:(void (^)(UserChannel *obj, NSHTTPURLResponse *res, NSError *err))block;

- (void)fetchUserProfileWithUserID:(int) userID withCompletion:(void (^)(UserProfileChannel *obj, NSHTTPURLResponse *res, NSError *err))block;

- (void)fetchAvailableSurveysWithUserID:(int) userID withCompletion:(void (^)(AvailableSurveyListChannel *obj, NSHTTPURLResponse *res, NSError *err))block;

- (void)fetchSurveyDetailsWithUserID:(int)userID withTaskID:(int)taskID withCompletion:(void (^)(SurveyChannel *obj, NSHTTPURLResponse *res, NSError *err))block;

- (void)fetchSurveyNextQuestionWithUserID:(int)userID withSurvey:(SurveyChannel *)surveyChannel withCompletion:(void (^)(SurveyChannel *obj, NSHTTPURLResponse *res, NSError *err))block;

- (void)submitSurveyWithUserID:(int)userID withSurvey:(SurveyChannel *)surveyChannel withCompletion:(void (^)(CreditChannel *obj, NSHTTPURLResponse *res, NSError *err))block;

- (void)fetchAvailableVouchersWithUserID:(int)userID withCompletion:(void (^)(RewardChannel *obj, NSHTTPURLResponse *res, NSError *err))block;

- (void)fetchUserRedemptionsWithUserID:(int)userID withCompletion:(void (^)(RewardChannel *obj, NSHTTPURLResponse *res, NSError *err))block;

- (void)purchaseVoucherWithUserID:(int)userID withVoucherID:(int)voucherID withVoucherCost:(double)voucherCost withCompletion:(void (^)(VoucherPurchasedChannel *obj, NSHTTPURLResponse *res, NSError *err))block;

- (void)purchaseVoucherWithUserID:(int)userID withVoucherID:(int)voucherID withVoucherCost:(double)voucherCost withUserInfo:(UserProfileChannel *)user withCompletion:(void (^)(VoucherPurchasedChannel *obj, NSHTTPURLResponse *res, NSError *err))block;

- (void)fetchUserNotificationsWithUserID:(int)userID withCompletion:(void (^)(NotificationListChannel *obj, NSHTTPURLResponse *res, NSError *err))block;

- (NSDictionary *)submitSurveyWithSynchronousRequestWithUserID:(int)userID withSurvey:(SurveyChannel *)surveyChannel;

@end
