//
//  AppDelegate.h
//  Sageby
//
//  Created by Mervyn on 15/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@class LoginViewController;
@class TabBarViewController;
@class SurveyChannel;
@class AvailableSurveyListChannel;
@class RewardChannel;
@class UserProfileChannel;
@class BlockView;
@class UserChannel;
@class SurveyListViewController;
@class ECSlidingViewController;
@class VendorAnnotation;
extern NSString *const FBSessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    NSMutableArray *regionArray;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) LoginViewController *loginvc;
@property (nonatomic, retain) TabBarViewController *tabvc;
@property (nonatomic, retain) BlockView *blockView;
@property (nonatomic, retain) ECSlidingViewController *slidingViewController;
//@property (nonatomic, retain) UserChannel *userChannel;
//@property (nonatomic, retain) UINavigationController *navController;

//@property (nonatomic, retain) UIView *errorPage;

// for UAT
@property (nonatomic, retain) SurveyChannel *surveyChannel;
@property (nonatomic, retain) SurveyChannel *surveyChannel2;
@property (nonatomic, retain) AvailableSurveyListChannel *availableSurveyListChannel;
@property (nonatomic, retain) RewardChannel *rewardChannel;
@property (nonatomic, retain) NSMutableArray *surveyDone;
@property (nonatomic, retain) NSMutableArray *voucherPurchase;
@property (nonatomic, retain) UserProfileChannel *userProfileChannel;
@property (nonatomic, retain) NSString *testType; // 'A' or 'B'
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) SurveyListViewController *surveyListvc;

- (void)customizeiPhoneTheme;
- (void)configureiPhoneTabBar;
- (void)configureTabBarItemWithImageName:(NSString*)imageName andText:(NSString *)itemText forViewController:(UIViewController *)viewController;
- (void)dummyDataInitialization;
- (BOOL)isUserLoggedIn;
- (int)getNSDefaultUserID;
- (NSString *)setFormatWithDate:(NSDate *)date;
- (void)openSessionWithAllowLoginUI:(BOOL)allowLoginUI  withShareType:(id)vc;
//- (void)userLogout;

- (void)startSignificantChangeUpdates;
- (double)getDistance:(VendorAnnotation *)vAnnot;

@end
