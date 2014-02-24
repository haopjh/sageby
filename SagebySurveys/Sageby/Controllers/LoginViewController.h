//
//  LoginViewController.h
//  Sageby
//
//  Created by Mervyn on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@class UserChannel;
@class AppDelegate;

@interface LoginViewController : UIViewController

@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, strong) AppDelegate *delegate;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *manualButton;

- (IBAction)loginViaFacebook:(id)sender;
- (IBAction)loginViaSageby:(id)sender;

- (BOOL)validateManualLoginFields;
- (void)storeLoginUserDetailsWithUserChannel:(UserChannel *)userChannel;
- (void)fbDidLoginWithSession:(FBSession *)session withUserDetails:(NSDictionary<FBGraphUser> *)userInfo;
- (void)goToSurvey;

@end