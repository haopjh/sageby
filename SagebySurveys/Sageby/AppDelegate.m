//
//  AppDelegate.m
//  Sageby
//
//  Created by Mervyn on 15/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ZUUIRevealController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "GANTracker.h"
#import "TabBarViewController.h"
#import "ShareViewController.h"
#import "SageByAPIStore.h"
#import "VendorAnnotation.h"
#import "ECSlidingViewController.h"

#import "SurveyChannel.h"
#import "RewardChannel.h"
#import "VoucherChannel.h"
#import "AvailableSurveyListChannel.h"
#import "SurveyQuestion.h"
#import "VoucherChannel.h"
#import "UserProfileChannel.h"
#import "BlockView.h"
#import "ATConnect.h"
#import "ATAppRatingFlow.h"

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;
static NSString* const kAnalyticsAccountId = @"UA-33411028-1";

@implementation AppDelegate

@synthesize window = _window, loginvc;
@synthesize surveyChannel, availableSurveyListChannel, rewardChannel, surveyChannel2, surveyDone, voucherPurchase, userProfileChannel, testType, blockView, tabvc, locationManager, slidingViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Initiate Apptentive
    NSString *kApptentiveAPIKey =
    @"1c6fcd90e6c47c5b3f783847adce642d701a78de15c230e38a991b9aa3eb00d7";
    ATConnect *connection = [ATConnect sharedConnection];
    connection.apiKey = kApptentiveAPIKey;
    
    ATAppRatingFlow *sharedFlow =
    [ATAppRatingFlow sharedRatingFlowWithAppID:@"550037522"];
    
    [sharedFlow appDidLaunch:YES viewController:self.window.rootViewController];
    
    [self customizeiPhoneTheme];
    
    //[self configureiPhoneTabBar];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.loginvc = [storyboard instantiateInitialViewController];
    
    self.slidingViewController = [storyboard instantiateViewControllerWithIdentifier: @"SlidingViewController"];
    self.tabvc = [storyboard instantiateViewControllerWithIdentifier: @"TabBarViewController"];
    self.slidingViewController.topViewController = self.tabvc;
    
    if ([self isUserLoggedIn]) {
        self.window.rootViewController = slidingViewController;
    } else {
        self.window.rootViewController = loginvc;
    }
    
    [self dummyDataInitialization];
    
    //Google Analytics
    [[GANTracker sharedTracker] startTrackerWithAccountID:kAnalyticsAccountId
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
    NSError *error;
    
    if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1
                                                         name:@"iOS1"
                                                        value:@"iv1"
                                                    withError:&error]) {
    }
    
    if (![[GANTracker sharedTracker] trackPageview:@"/Login View"
                                         withError:&error]) {
        NSLog(@"error in trackPageview");
    }
    
    NSLog(@"Launched GA");
    [self.window makeKeyAndVisible];
    
    //Start locating location of user
    if ([self isUserLoggedIn]) {
        [self startSignificantChangeUpdates];
        application.applicationIconBadgeNumber = 0;
        NSLog(@"This is the number of badges: %d",application.applicationIconBadgeNumber);
    }
    
    return YES;
}

- (void)setRootView:(id)viewController
{
    self.window.rootViewController = viewController;
}

- (BOOL)isUserLoggedIn
{
    BOOL isLoggedIn = FALSE;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"SagebyUserID"]) {
        if ([defaults objectForKey:@"FBAccessTokenKey"]
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            if (FBSession.activeSession) {
                isLoggedIn = TRUE;  //check facebook login
            }
        } else {
            isLoggedIn = TRUE;   //check manual login
        }
    }
    return isLoggedIn;
}

- (int)getNSDefaultUserID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:@"SagebyUserID"] intValue];
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (void)openSessionWithAllowLoginUI:(BOOL)allowLoginUI withShareType:(id)vc
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"offline_access", @"publish_stream", @"read_stream", @"publish_actions", @"email", nil];
    [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:allowLoginUI completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        switch (state) {
            case FBSessionStateOpen:
                if (!error) {
                    NSLog(@"share");
                    if (allowLoginUI) {
                        self.loginvc.facebookButton.enabled = NO;
                        // We have a valid session
                        FBRequest *me = [FBRequest requestForMe];
                        [me startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *my, NSError *error) {
                            if (!error) {
                                NSHTTPURLResponse *res = (NSHTTPURLResponse *)[connection urlResponse];
                                if ([res statusCode] == 200) {
                                    [self.loginvc fbDidLoginWithSession:session withUserDetails:my];
                                }
                            }
                        }];
                    } else if ([vc isMemberOfClass:NSClassFromString(@"SettingsViewController")]) {
                        ShareViewController *sharevc = [[ShareViewController alloc] init];
                        [sharevc setShareType:ShareViewControllerShareTypeApp];
                        [vc presentModalViewController:sharevc animated:YES];
                    } else if ([vc isMemberOfClass:NSClassFromString(@"SurveyCompleteViewController")]) {
                        ShareViewController *sharevc = [[ShareViewController alloc] init];
                        [sharevc setShareType:ShareViewControllerShareTypeReferral];
                        [vc presentModalViewController:sharevc animated:YES];
                    }
                }
                NSLog(@"FBSessionStateOpen");
                break;
            case FBSessionStateClosed:
                NSLog(@"FBSessionStateClosed");
                break;
            case FBSessionStateClosedLoginFailed:
                NSLog(@"FBSessionStateClosedLoginFailed");
                [FBSession.activeSession closeAndClearTokenInformation];
                break;
            default:
                NSLog(@"default");
                break;
        }
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Error"
                                      message:error.localizedDescription
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void)dummyDataInitialization
{
    self.surveyDone = [[NSMutableArray alloc] init];
    self.rewardChannel = [[RewardChannel alloc] init];
    self.voucherPurchase = [[NSMutableArray alloc] init];
    self.userProfileChannel = [[UserProfileChannel alloc] init];
    self.testType = @"B"; //change between "A" and "B"
    
    SurveyQuestion *sq1 = [[SurveyQuestion alloc] init];
    [sq1 setQuestionID:1];
    [sq1 setQuestion:@"If you are given a choice, would you complete 2 half an hour surveys for $50?"];
    [sq1 setQuestionType:@"SCQ"];
    [sq1 setOptional:NO];
    NSArray *keys1 = [NSArray arrayWithObjects:@"1", @"2", nil];
    NSArray *objects1 = [NSArray arrayWithObjects:@"Yes", @"No", nil];
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:objects1 forKeys:keys1];
    [sq1 setAnswerOptions:dict1];
    
    SurveyQuestion *sq2 = [[SurveyQuestion alloc] init];
    [sq2 setQuestionID:6];
    [sq2 setQuestion:@"What kind of survey styles do you prefer to have?"];
    [sq2 setQuestionType:@"Rank"];
    [sq2 setOptional:NO];
    NSArray *keys2 = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    NSArray *objects2 = [NSArray arrayWithObjects:@"Checkbox", @"Radio", @"Arrangeable boxes", @"Free text", @"Rating", nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjects:objects2 forKeys:keys2];
    [sq2 setAnswerOptions:dict2];
    
    SurveyQuestion *sq3 = [[SurveyQuestion alloc] init];
    [sq3 setQuestionID:2];
    [sq3 setQuestion:@"How often will you attempt surveys?"];
    [sq3 setQuestionType:@"SCQ"];
    [sq3 setOptional:NO];
    NSArray *keys3 = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
    NSArray *objects3 = [NSArray arrayWithObjects:@"Never", @"less than or 5 surveys a month", @"more than 5 surveys a month", nil];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjects:objects3 forKeys:keys3];
    [sq3 setAnswerOptions:dict3];
    
    SurveyQuestion *sq4 = [[SurveyQuestion alloc] init];
    [sq4 setQuestionID:4];
    [sq4 setQuestion:@"Please rate our application's color scheme."];
    [sq4 setQuestionType:@"Rating"];
    [sq4 setOptional:NO];
    [sq4 setMin:0];
    [sq4 setMax:10];
    [sq4 setIncrement:1];
    NSArray *keys4 = [NSArray arrayWithObjects:nil];
    NSArray *objects4 = [NSArray arrayWithObjects:nil];
    NSDictionary *dict4 = [NSDictionary dictionaryWithObjects:objects4 forKeys:keys4];
    [sq4 setAnswerOptions:dict4];
    
    SurveyQuestion *sq5 = [[SurveyQuestion alloc] init];
    [sq5 setQuestionID:5];
    [sq5 setQuestion:@"Kindly provide suggestions to help us improve on our design and application features."];
    [sq5 setQuestionType:@"Text"];
    [sq5 setOptional:NO];
    NSArray *keys5 = [NSArray arrayWithObjects:nil];
    NSArray *objects5 = [NSArray arrayWithObjects:nil];
    NSDictionary *dict5 = [NSDictionary dictionaryWithObjects:objects5 forKeys:keys5];
    [sq5 setAnswerOptions:dict5];
    
    SurveyQuestion *sq6 = [[SurveyQuestion alloc] init];
    [sq6 setQuestionID:3];
    [sq6 setQuestion:@"What type of discount vouchers would you prefer to receive?"];
    [sq6 setQuestionType:@"MCQ"];
    [sq6 setOptional:NO];
    NSArray *keys6 = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    NSArray *objects6 = [NSArray arrayWithObjects:@"food", @"sport", @"book", @"fashion", @"supermarket", nil];
    NSDictionary *dict6 = [NSDictionary dictionaryWithObjects:objects6 forKeys:keys6];
    [sq6 setAnswerOptions:dict6];
    
    NSMutableArray *questions = [NSMutableArray arrayWithObjects:sq1, sq3, sq6, sq5, sq4, sq2, nil];
    
    self.surveyChannel = [[SurveyChannel alloc] init];
    self.surveyChannel2 = [[SurveyChannel alloc] init];
    [[self surveyChannel] setTaskID:1];
    [[self surveyChannel] setTitle:@"Survey for MidTerm"];
    [[self surveyChannel] setDescription:@"Hi! Team Sageby will be grateful if you complete this survey for our second UAT"];
    //    [[self surveyChannel] setMerchantName:@"Team Sageby"];
    [[self surveyChannel] setIsQuestionRouting:NO];
    [[self surveyChannel] setSurveyImageFile:nil];
    [[self surveyChannel] setSurveyQuestions:questions];
    [[self surveyChannel] setTimeNeeded:10];
    
    [[self surveyChannel2] setTaskID:12];
    [[self surveyChannel2] setTitle:@"Survey for UAT1"];
    [[self surveyChannel2] setDescription:@"Hi! Team Sageby will be grateful if you complete this survey for our first UAT"];
    //    [[self surveyChannel2] setMerchantName:@"Team Sageby"];
    [[self surveyChannel2] setIsQuestionRouting:NO];
    [[self surveyChannel2] setSurveyImageFile:nil];
    [[self surveyChannel2] setSurveyQuestions:questions];
    [[self surveyChannel2] setTimeNeeded:15];
    
    NSMutableArray *list = [NSMutableArray arrayWithObjects:[self surveyChannel2], [self surveyChannel], nil];
    self.availableSurveyListChannel = [[AvailableSurveyListChannel alloc] init];
    [[self availableSurveyListChannel] setAvailableSurveyList:list];
    
    VoucherChannel *v1 = [[VoucherChannel alloc] init];
    [v1 setVoucherID:1];
    [v1 setTitle:@"Milkshake voucher"];
    [v1 setType:@"Digital"];
    [v1 setQrCodePathString:@"Milkshake voucher"];
    //    [v1 setHasUserPurchased:YES];
    
    VoucherChannel *v2 = [[VoucherChannel alloc] init];
    [v2 setVoucherID:2];
    [v2 setTitle:@"Subway voucher"];
    [v2 setType:@"Digital"];
    [v2 setQrCodePathString:@"Subway voucher"];
    //    [v2 setHasUserPurchased:YES];
    
    [[[self rewardChannel] voucherList] addObject:v1];
    [[[self rewardChannel] voucherList] addObject:v2];
}

- (NSString *)setFormatWithDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    return textDate;
}

- (void)customizeiPhoneTheme
{
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    UIImage *navBarImage = [UIImage imageNamed:@"menubarblue.png"];
    
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    
    UIImage *barButton = [[UIImage imageNamed:@"menubar-button-blue.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [[UIImage imageNamed:@"backblue.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"leathertab.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    /*
     UIImage *minImage = [UIImage imageNamed:@"ipad-slider-fill"];
     UIImage *maxImage = [UIImage imageNamed:@"ipad-slider-track.png"];
     UIImage *thumbImage = [UIImage imageNamed:@"ipad-slider-handle.png"];
     
     [[UISlider appearance] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
     [[UISlider appearance] setMinimumTrackImage:minImage forState:UIControlStateNormal];
     [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateNormal];
     [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateHighlighted];
     
     [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar-active.png"]];
     */
}

-(void)configureiPhoneTabBar
{
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
	
    UIViewController *controller1 = [[tabBarController viewControllers] objectAtIndex:0];
    [self configureTabBarItemWithImageName:@"tab-icon1.png" andText:@"Survey" forViewController:controller1];
    
    
    UIViewController *controller2 = [[tabBarController viewControllers] objectAtIndex:1];
    [self configureTabBarItemWithImageName:@"tab-icon2.png" andText:@"Rewards" forViewController:controller2];
    
    
    UIViewController *controller3 = [[tabBarController viewControllers] objectAtIndex:2];
    [self configureTabBarItemWithImageName:@"tab-icon3.png" andText:@"Settings" forViewController:controller3];
    
    /*
     UIViewController *controller4 = [[tabBarController viewControllers] objectAtIndex:3];
     [self configureTabBarItemWithImageName:@"tab-icon4.png" andText:@"Nearby" forViewController:controller4];
     */
}

-(void)configureTabBarItemWithImageName:(NSString*)imageName andText:(NSString *)itemText forViewController:(UIViewController *)viewController
{
    UIImage* icon1 = [UIImage imageNamed:imageName];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:itemText image:icon1 tag:0];
    [item1 setFinishedSelectedImage:icon1 withFinishedUnselectedImage:icon1];
    
    [viewController setTabBarItem:item1];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    application.applicationIconBadgeNumber = 0;
    NSLog(@"Badges is set to %d",application.applicationIconBadgeNumber);
    ATAppRatingFlow *sharedFlow =
    [ATAppRatingFlow sharedRatingFlowWithAppID:@"550037522"];
    [sharedFlow appDidEnterForeground:YES viewController:self.window.rootViewController];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // [[GANTracker sharedTracker] stopTracker];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 called when the Facebook App redirects to the app during the SSO process. The call to Facebook::handleOpenURL: provides the app with the user's credentials.
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)dealloc {
    [[GANTracker sharedTracker] stopTracker];
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 20;
    
    [locationManager startUpdatingLocation];
    [locationManager startMonitoringSignificantLocationChanges];
    [self monitorRegion];
    NSLog(@"Standard update is running!");
}
- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    [locationManager startMonitoringSignificantLocationChanges];
    [self monitorRegion];
    NSLog(@"Significant update is running!");
}
// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}

- (double)getDistance:(VendorAnnotation *)vAnnot
{
    CLLocation* myLoc = locationManager.location;
    if(myLoc){
        CLLocation* theLoc = [[CLLocation alloc] initWithLatitude:[vAnnot.latitude doubleValue] longitude:[vAnnot.longitude doubleValue]];
        CLLocationDistance distance = [myLoc distanceFromLocation:theLoc]/1000;
        return distance;
    }else{
        return -1.0;
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
    CLLocation* myLoc = manager.location;
    CLLocation* theLoc = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
    CLLocationDistance distance = [myLoc distanceFromLocation:theLoc];
    NSLog(@"You entered the area with distance %f!",distance);
    
    //Junhao is unable to find the source of the problem
    //where multiple regions is entered despite being more than 1km apart
    //Hence Junhao have decided to pluck out the distance between them and
    //use it as a if/else criteria
    if (distance < 100) {
        //UI appear in app
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"You are near %@! Do check out our available vouchers for that vendor.",[region identifier]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        
        //Appeared out of app
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil)
            return;
        localNotif.fireDate = [[NSDate alloc]init];
        
        NSLog(@"The time is: %@", [[NSDate alloc]init]);
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotif.alertBody = [NSString stringWithFormat:@"You are near %@! Do check out our available vouchers for that vendor.",[region identifier]];
        localNotif.alertAction = NSLocalizedString(@"View Details", nil);
        
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber+1;
        NSLog(@"This is the number of badges: %d",localNotif.applicationIconBadgeNumber);
        
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[region identifier] forKey:@"vendor"];
        localNotif.userInfo = infoDict;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
    
}

- (void) monitorRegion
{
    void (^completionBlock)(RewardChannel *obj, NSHTTPURLResponse *res, NSError *err) =
    ^(RewardChannel *obj, NSHTTPURLResponse *res, NSError *err) {
        if(!err){
            if ([res statusCode] == 200) {
                if (![obj errorMsg]) {
                    rewardChannel = obj;
                    int count = 0;
                    if ([self rewardChannel]) {
                        for (int i=0; i<[self.rewardChannel.voucherList count]; i++) {
                            VoucherChannel *voucher = [self.rewardChannel.voucherList objectAtIndex:i];
                            if ([voucher vendorAnnotationList]) {
                                for (int k=0; k<[[voucher vendorAnnotationList] count]; k++) {
                                    VendorAnnotation *vendorAnnotation = [[voucher vendorAnnotationList] objectAtIndex:k];
                                    [vendorAnnotation setVoucherChannel:voucher];
                                    
                                    CLLocationCoordinate2D center = CLLocationCoordinate2DMake([vendorAnnotation.latitude doubleValue], [vendorAnnotation.longitude doubleValue]);
                                    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:center radius:20.0f identifier:[NSString stringWithFormat:@"%@", [voucher title]]];
                                    [locationManager startMonitoringForRegion:region desiredAccuracy:kCLLocationAccuracyBest];
                                    count ++;
                                }
                            }
                        }
                    }
                }
            }
        }
    };
    
    [[SageByAPIStore sharedStore] fetchAvailableVouchersWithUserID:[self getNSDefaultUserID] withCompletion:completionBlock];
    
    
    //    CLLocationCoordinate2D center1 = CLLocationCoordinate2DMake([@"1.301468" doubleValue], [@"103.845213" doubleValue]);
    //    CLRegion *region1 = [[CLRegion alloc] initCircularRegionWithCenter:center1 radius:45.0f identifier:@"SMU SIS"];
    //    CLLocationCoordinate2D center2 = CLLocationCoordinate2DMake([@"1.291996" doubleValue], [@"103.855732" doubleValue]);
    //    CLRegion *region2 = [[CLRegion alloc] initCircularRegionWithCenter:center2 radius:45.0f identifier:@"Mervyn's House"];
    //    CLLocationCoordinate2D center3 = CLLocationCoordinate2DMake([@"1.290774" doubleValue], [@"103.84181" doubleValue]);
    //    CLRegion *region3 = [[CLRegion alloc] initCircularRegionWithCenter:center3 radius:45.0f identifier:@"Luojia's House"];
    //    CLLocationCoordinate2D center4 = CLLocationCoordinate2DMake([@"1.311663" doubleValue], [@"103.855632" doubleValue]);
    //    CLRegion *region4 = [[CLRegion alloc] initCircularRegionWithCenter:center4 radius:45.0f identifier:@"Junhao's House"];
    //    CLLocationCoordinate2D center5 = CLLocationCoordinate2DMake([@"1.297601" doubleValue], [@"103.849597" doubleValue]);
    //    CLRegion *region5 = [[CLRegion alloc] initCircularRegionWithCenter:center5 radius:45.0f identifier:@"Junhao's House"];
    //
    //    [locationManager startMonitoringForRegion:region1 desiredAccuracy:kCLLocationAccuracyBest];
    //    [locationManager startMonitoringForRegion:region2 desiredAccuracy:kCLLocationAccuracyBest];
    //    [locationManager startMonitoringForRegion:region3 desiredAccuracy:kCLLocationAccuracyBest];
    //    [locationManager startMonitoringForRegion:region4 desiredAccuracy:kCLLocationAccuracyBest];
    //    [locationManager startMonitoringForRegion:region5 desiredAccuracy:kCLLocationAccuracyBest];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {
    //    NSString *itemName = [notif.userInfo objectForKey:ToDoItemKey]
    //    [viewController displayItem:itemName];  // custom method
    application.applicationIconBadgeNumber = 0;
    NSLog(@"Badges is set to %d",application.applicationIconBadgeNumber);
}

@end
