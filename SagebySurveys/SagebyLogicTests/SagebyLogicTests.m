//
//  SagebyLogicTests.m
//  SagebyLogicTests
//
//  Created by Jun Hao Peh on 28/8/12.
//
//

#import "SagebyLogicTests.h"
#import "CheckboxViewController.h"
#import "RadioTemplateViewController.h"
#import "TextboxTemplateViewController.h"
#import "RatingTemplateViewController.h"
#import "AvailableSurveyListChannel.h"


@implementation SagebyLogicTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    appDelegate = [[UIApplication sharedApplication] delegate];
    //mainNavigationController = (UINavigationController*) appDelegate.window.rootViewController;
    //loginvc = (LoginViewController *) mainNavigationController.visibleViewController;
    
    loginvc = (LoginViewController *) appDelegate.window.rootViewController;
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in SagebyLogicTests");
}

- (void)testCheckboxNoOption
{
    _Bool results = [[CheckboxViewController alloc] hasUserAnswered];
    STAssertFalseNoThrow(results, @"Rejects if no answer is provided");
    
}

- (void)testRadioNoOption
{
    _Bool results = [[RadioTemplateViewController alloc] hasUserAnswered];
    STAssertFalseNoThrow(results, @"Rejects if no answer is provided");
}

- (void)testTextboxNoOption
{
    _Bool results = [[TextboxTemplateViewController alloc] hasUserAnswered];
    STAssertFalseNoThrow(results, @"Rejects if no answer is provided");
}

-(void)testManualLogin
{
    STAssertTrue([appDelegate isMemberOfClass:[AppDelegate class]], @"bad UIApplication delegate");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"SagebyUserID"]) {
        UITextField *username = (UITextField *)loginvc.usernameTextField;
        UITextField *password = (UITextField *)loginvc.passwordTextField;
        
        _Bool results = [loginvc validateManualLoginFields];
        STAssertFalseNoThrow(results, @"No Credentials provided");
        
        [username setText:@"testuser"];
        results = [loginvc validateManualLoginFields];
        STAssertFalseNoThrow(results, @"No password provided");
        
        [password setText:@"password"];
        results = [loginvc validateManualLoginFields];
        STAssertTrueNoThrow(results, @"All credentials provided");
        
        [username setText:@""];
        results = [loginvc validateManualLoginFields];
        STAssertFalseNoThrow(results, @"No username provided");
    }
}
- (void)testMockDataGeneration
{
    [appDelegate dummyDataInitialization];
    AvailableSurveyListChannel *list = appDelegate.availableSurveyListChannel;
    STAssertTrue(sizeof(list.availableSurveyList) > 0,@"Surveys is generated");
}

@end
