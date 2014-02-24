//
//  WebViewController.h
//  Sageby
//
//  Created by LuoJia on 27/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SurveyChannel;
@class AppDelegate;

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) SurveyChannel *surveyChannel;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) UIViewController *toProceedvc;
@property (weak, nonatomic) IBOutlet UIView *exitSurveyPopupView;
@property (weak, nonatomic) IBOutlet UIWebView *externalSurveyView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;

- (IBAction)closeExitSurveyPopup:(id)sender;
- (IBAction)confirmExitSurveyView:(id)sender;

- (NSDictionary *)detectEndSurvey;
- (void)showSurveyCompletedWithCreditChannel:(NSData *)responseData;
- (void)openExitSurveyPopup:(id)sender;

@end
