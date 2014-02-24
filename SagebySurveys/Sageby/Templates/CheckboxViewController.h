//
//  CheckboxViewController.h
//  checker
//
//  Created by Mervyn on 17/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SurveyChannel;
@class SurveyQuestion;
@class AppDelegate;
@class ConfirmationPopupView;

@interface CheckboxViewController : UIViewController

@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) ConfirmationPopupView *confirmationPopupView;
@property (nonatomic, strong) SurveyChannel *surveyChannel;
@property (nonatomic, strong) SurveyQuestion *surveyQuestion;
@property (nonatomic, retain) NSDictionary *arForTable;
@property (nonatomic, retain) NSMutableArray *arForIPs;
@property (weak, nonatomic) IBOutlet UILabel *questionsLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;
@property (weak, nonatomic) IBOutlet UILabel *qLabel;

- (BOOL)hasUserAnswered;
- (void)storeUserAnswer;
- (void)performTransaction;

@end
