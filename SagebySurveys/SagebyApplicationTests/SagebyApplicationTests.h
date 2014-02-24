//
//  SagebyApplicationTests.h
//  SagebyApplicationTests
//
//  Created by Jun Hao Peh on 28/8/12.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface SagebyApplicationTests : SenTestCase{
    AppDelegate *appDelegate;
    //UINavigationController *mainNavigationController;
    LoginViewController *loginvc;
}

@end
