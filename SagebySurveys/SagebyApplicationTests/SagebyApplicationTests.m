//
//  SagebyApplicationTests.m
//  SagebyApplicationTests
//
//  Created by Jun Hao Peh on 28/8/12.
//
//

#import "SagebyApplicationTests.h"
#import "SurveyListViewController.h"
#import "TabBarViewController.h"
#import "AvailableSurveyListChannel.h"
#import "SettingsViewController.h"
#import "SurveyDetailsViewController.h"
#import "WebViewController.h"

@implementation SagebyApplicationTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    loginvc = (LoginViewController *) appDelegate.window.rootViewController;
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)test1ApplicationDelegate
{
    STAssertTrue([appDelegate isMemberOfClass:[AppDelegate class]], @"bad UIApplication delegate");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"SagebyUserID"]) {
        STAssertTrue([appDelegate.window.rootViewController isMemberOfClass:[TabBarViewController class]],@"bad mainViewController");
    }
    else {
        STAssertTrue([appDelegate.window.rootViewController isMemberOfClass:[LoginViewController class]],@"bad mainViewController");
    }
}

- (void)test2ManualLoginButton
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"SagebyUserID"]) {
        STAssertTrue([loginvc isMemberOfClass:[LoginViewController class]], @"");
        UIButton *nextButton = (UIButton*)[loginvc.view viewWithTag:3];
        [nextButton sendActionsForControlEvents:(UIControlEventTouchUpInside)];
        STAssertTrue(appDelegate.window.rootViewController == loginvc, @"empty name check did not work"); //should not go to next view as username textfield is empty
        
        UITextField *username = (UITextField*)[loginvc.view viewWithTag:1];
        username.text = @"testuser";
        UITextField *password = (UITextField*)[loginvc.view viewWithTag:2];
        password.text = @"password";
        
        //press login button
        [nextButton sendActionsForControlEvents:(UIControlEventTouchUpInside)];
        
        //Check location
        STAssertTrue([appDelegate.window.rootViewController isMemberOfClass:[TabBarViewController class]], @"");
        TabBarViewController *vc = (TabBarViewController *)appDelegate.window.rootViewController;
        int index = vc.selectedIndex;
        STAssertEquals(index, 0, @"Survey list view controller");
    }
}

- (void)test3ClickOnSurvey
{
    [appDelegate dummyDataInitialization];
    TabBarViewController *vc = (TabBarViewController *)appDelegate.window.rootViewController;
    int index = vc.selectedIndex;
    STAssertEquals(index, 0, @"Survey list view controller!");
    AvailableSurveyListChannel *availableSurveyListChannel = [appDelegate availableSurveyListChannel];
    int count = [[availableSurveyListChannel availableSurveyList] count];
    STAssertTrue(count > 0, @"Surveys are generated!");
    
    UINavigationController *navvc = (UINavigationController *)vc.selectedViewController;
    STAssertTrue([navvc isMemberOfClass:[UINavigationController class]], @"Correct navigation controller");
    SurveyListViewController *surveyvc = (SurveyListViewController *)navvc.visibleViewController;
    STAssertTrue([surveyvc isMemberOfClass:[SurveyListViewController class]], @"Correct View Controller");
    UITableView *table = (UITableView *)[surveyvc.view viewWithTag:1];
    
    //Chooses a survey from the table
    [surveyvc tableView:table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    vc = (TabBarViewController *)appDelegate.window.rootViewController;
    navvc = (UINavigationController *)vc.selectedViewController;
    SurveyDetailsViewController *surveydetailsvc = (SurveyDetailsViewController *)navvc.visibleViewController;
    STAssertTrue([surveydetailsvc isMemberOfClass:[SurveyDetailsViewController class]], @"Survey Details");
    
    //Clicks on start button
    UIButton *nextButton = (UIButton*)[surveydetailsvc.view viewWithTag:1];
    [nextButton sendActionsForControlEvents:(UIControlEventTouchUpInside)];
    STAssertFalse([surveydetailsvc isMemberOfClass:[WebViewController class]], @"Started Surveys");
    
}

- (void)test4Aboutbutton{
    STAssertTrue([appDelegate.window.rootViewController isMemberOfClass:[TabBarViewController class]],@"bad mainViewController");
    TabBarViewController *vc = (TabBarViewController *)appDelegate.window.rootViewController;
    int index = vc.selectedIndex;
    STAssertEquals(index, 0, @"Survey list view controller!");
    
    vc.selectedIndex = 2;
    index = vc.selectedIndex;
    STAssertEquals(index, 2, @"Settings view controller!");
    UINavigationController *navvc = (UINavigationController *)vc.selectedViewController;
    STAssertTrue([navvc isMemberOfClass:[UINavigationController class]], @"");
    SettingsViewController *settingsvc = (SettingsViewController *)navvc.visibleViewController;
    NSLog(@"!!!settingsvc %@",settingsvc);
    STAssertTrue([settingsvc isMemberOfClass:[SettingsViewController class]], @"");
//    UITableView *table = (UITableView *)[settingsvc.view viewWithTag:1];
//    [settingsvc tableView:table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    STAssertTrue([appDelegate.window.rootViewController isMemberOfClass:[TabBarViewController class]],@"bad mainViewController");
}

//- (void)test6Logout
//{
//    STAssertTrue([appDelegate.window.rootViewController isMemberOfClass:[TabBarViewController class]],@"bad mainViewController");
//    TabBarViewController *vc = (TabBarViewController *)appDelegate.window.rootViewController;
//    int index = vc.selectedIndex;
//    STAssertEquals(index, 2, @"Settings view controller!");
//    
//    UINavigationController *navvc = (UINavigationController *)vc.selectedViewController;
//    STAssertTrue([navvc isMemberOfClass:[UINavigationController class]], @"");
//    SettingsViewController *settingsvc = (SettingsViewController *)navvc.visibleViewController;
//    STAssertTrue([settingsvc isMemberOfClass:[SettingsViewController class]], @"");
//    UITableView *table = (UITableView *)[settingsvc.view viewWithTag:1];
//    [settingsvc tableView:table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//    STAssertTrue([appDelegate.window.rootViewController isMemberOfClass:[LoginViewController class]],@"bad mainViewController");
//}

@end
