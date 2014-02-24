//
//  SurveyCompleteViewController.h
//  Sageby
//
//  Created by Mervyn on 24/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>

@class CreditChannel;
@class AppDelegate;

@interface SurveyCompleteViewController : UIViewController

@property (nonatomic, strong) CreditChannel *creditChannel;
@property (nonatomic, strong) AppDelegate *delegate;

@property (weak, nonatomic) IBOutlet UILabel *lblCreditedAmount;
@property (weak, nonatomic) IBOutlet UIButton *surveyPageBtn;

- (IBAction)goSurveyPage:(id)sender;
- (IBAction)goFaceBookShare:(id)sender;
- (IBAction)goTwitterShare:(id)sender;

@end
