//
//  SagebyTests.h
//  SagebyTests
//
//  Created by Mervyn on 15/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface SagebyTests : SenTestCase{
    AppDelegate *appDelegate;
    UINavigationController *mainNavigationController;
    LoginViewController *loginvc;
}


@end
