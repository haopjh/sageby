//
//  SettingsViewController.h
//  Sageby
//
//  Created by LuoJia on 25/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
@class AppDelegate;

@interface SettingsViewController : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSArray *tableData;
    NSArray *tableLogoutData;
}

@property (nonatomic, strong) AppDelegate *delegate;

- (void)userLogout;

@end
