//
//  TabBarViewController.m
//  Sageby
//
//  Created by LuoJia on 16/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabBarViewController.h"

#import "SurveyListViewController.h"
#import "RewardListViewController.h"
#import "SettingsViewController.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "RadioTemplateViewController.h"
#import "CheckboxViewController.h"
#import "RatingTemplateViewController.h"
#import "TextboxTemplateViewController.h"
#import "ArrangableBoxesViewController.h"
#import "ConfirmationPopupView.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController
@synthesize tabBar;
@synthesize selectedIndex;
@synthesize needConfirmationvc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [self setTabBar:nil];
    [self setSelectedIndex:0];
    [self setNeedConfirmationvc:nil];
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BOOL shouldSelect = YES;
    UINavigationController *navigationContoller = (UINavigationController *)viewController;
    NSLog(@"begin");
    if (navigationContoller.visibleViewController) {
        NSLog(@"visible");
        if ([needConfirmationvc isMemberOfClass:NSClassFromString(@"WebViewController")]) {
            shouldSelect = NO;
            WebViewController *newvc = (WebViewController *)needConfirmationvc;
            [newvc setToProceedvc:navigationContoller];
            [newvc openExitSurveyPopup:nil];
        } else if ([needConfirmationvc isMemberOfClass:NSClassFromString(@"RadioTemplateViewController")] || [needConfirmationvc isMemberOfClass:NSClassFromString(@"CheckboxViewController")] || [needConfirmationvc isMemberOfClass:NSClassFromString(@"RatingTemplateViewController")] || [needConfirmationvc isMemberOfClass:NSClassFromString(@"TextboxTemplateViewController")] || [needConfirmationvc isMemberOfClass:NSClassFromString(@"ArrangableBoxesViewController")]) {
            if (![[navigationContoller topViewController] isMemberOfClass:NSClassFromString(@"RewardListViewController")] && ![[navigationContoller topViewController] isMemberOfClass:NSClassFromString(@"SettingsViewController")]) {
                NSLog(@"class %@: ", [navigationContoller topViewController]);
                shouldSelect = NO;
                ConfirmationPopupView *confirmationPopupView = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmationPopupView" owner:self options:nil] objectAtIndex:0];
                confirmationPopupView.frame = CGRectMake(20, 70, 280, 180);
                [self.needConfirmationvc.view addSubview:confirmationPopupView];
                [confirmationPopupView setConfirmationType:ConfirmationPopupViewTypeSurveyExit];
                [confirmationPopupView setSourceVC:self.needConfirmationvc];
                [confirmationPopupView setToProceedvc:navigationContoller];
                [confirmationPopupView showConfirmationView];
            }
        }
    }
    return shouldSelect;
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    NSUInteger indexOfTab = [theTabBarController.viewControllers indexOfObject:viewController];
    self.selectedIndex = indexOfTab;
}

@end
