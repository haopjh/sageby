//
//  TabBarViewController.h
//  Sageby
//
//  Created by LuoJia on 16/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface TabBarViewController : UITabBarController <UITabBarControllerDelegate>

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@property (nonatomic, strong) UIViewController *needConfirmationvc;

@end
