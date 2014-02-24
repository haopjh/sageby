//
//  SurveyViewController.h
//  Sageby
//
//  Created by Mervyn on 12/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "NotificationViewController.h"

@class AvailableSurveyListChannel;
@class AppDelegate;
@class BlockView;
@class ProfileView;

@interface SurveyListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    AvailableSurveyListChannel *availableSurveyListChannel;
}


@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) ProfileView *profileView;
@property (nonatomic, strong) UIImageView *errorImgView;
@property (weak, nonatomic) IBOutlet BlockView *blockView;
@property (weak, nonatomic) IBOutlet UITableView *surveyTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;

- (IBAction)openUserProfilePopup:(id)sender;
- (IBAction)revealMenu:(id)sender;
- (void) fetchEntries;
@end
