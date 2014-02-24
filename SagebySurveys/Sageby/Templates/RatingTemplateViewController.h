//
//  RatingTemplateViewController.h
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

@interface RatingTemplateViewController : UIViewController
{
    __weak IBOutlet UISlider *slider;
    __weak IBOutlet UILabel *ratingLabel;
    __weak IBOutlet UILabel *minValue;
    __weak IBOutlet UILabel *maxValue;
    
    NSMutableArray *theArray;
}
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) ConfirmationPopupView *confirmationPopupView;
@property (nonatomic, strong) SurveyChannel *surveyChannel;
@property (nonatomic, strong) SurveyQuestion *surveyQuestion;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;

- (IBAction)changeRatingLabelValue;

- (BOOL)hasUserAnswered;
- (void)storeUserAnswer;
- (void)performTransaction;

@end
