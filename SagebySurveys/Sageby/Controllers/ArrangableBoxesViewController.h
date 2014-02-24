//
//  ArrangableBoxesViewController.h
//  Sageby
//
//  Created by LuoJia on 16/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SurveyChannel;
@class SurveyQuestion;
@class AppDelegate;
@class ConfirmationPopupView;

@interface ArrangableBoxesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ConfirmationPopupView *confirmationPopupView;
@property (nonatomic, strong) SurveyChannel *surveyChannel;
@property (nonatomic, strong) SurveyQuestion *surveyQuestion;
@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, retain) NSDictionary *arForTable;
@property (nonatomic, retain) NSMutableArray *arForIPs;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITableView *arrangableTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;
@property (weak, nonatomic) IBOutlet UILabel *qLabel;

- (BOOL)hasUserAnswered;
- (void)storeUserAnswer;
- (void)performTransaction;

@end
