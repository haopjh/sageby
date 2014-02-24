//
//  RadioTemplateViewController.h
//  Sageby
//
//  Created by Mervyn on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SurveyChannel;
@class SurveyQuestion;
@class AppDelegate;
@class ConfirmationPopupView;

@interface RadioTemplateViewController : UIViewController{
    CGRect myFrame;
}

@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) ConfirmationPopupView *confirmationPopupView;
@property (nonatomic, retain) NSDictionary *arForTable;
@property (nonatomic, retain) NSMutableArray *arForIPs;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *contentsList;
@property (nonatomic, strong) SurveyChannel *surveyChannel;
@property (nonatomic, strong) SurveyQuestion *surveyQuestion;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *qLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;

- (void)storeUserAnswer;
- (BOOL)hasUserAnswered;
- (void)performTransaction;

@end
