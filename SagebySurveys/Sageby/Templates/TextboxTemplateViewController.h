//
//  TextboxTemplateViewController.h
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

@interface TextboxTemplateViewController : UIViewController
{
    
    __weak IBOutlet UITextField *answerField;
    NSMutableArray *theArray;
}
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) ConfirmationPopupView *confirmationPopupView;
@property (nonatomic, strong) SurveyChannel *surveyChannel;
@property (nonatomic, strong) SurveyQuestion *surveyQuestion;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;

- (BOOL)hasUserAnswered;
- (void)storeUserAnswer;
- (void)performTransaction;

@end
