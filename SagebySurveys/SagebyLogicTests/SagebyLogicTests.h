//
//  SagebyLogicTests.h
//  SagebyLogicTests
//
//  Created by Jun Hao Peh on 28/8/12.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface SagebyLogicTests : SenTestCase{
    AppDelegate *appDelegate;
    //UINavigationController *mainNavigationController;
    LoginViewController *loginvc;
}

@end